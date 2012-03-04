# The PostingsController provides functionality for creating and editing 
# postings (freights and loading_spaces).
#
# Both the FreightsController and the LoadingSpacesController inherit from here.
#
if Rails.env == 'development'
  require_dependency 'uploaded/sheet' 
  require_dependency 'uploaded/posting' 
end
class PostingsController < RemoteController
  same_company_required :only => %w(edit update destroy)
  role_required [:company_admin, :company_employee], :only => [:new, :create, :edit, :update, :destroy]
  
  def new
    if parent = params[:parent_id].full? { |id| resource_class.find(id) }
      self.resource = resource_class.new(parent.attributes.clone)
      parent.localized_infos.each do |li|
        resource.localized_infos.build(li.attributes)
      end
      if resource.company != current_company
        resource.parent = parent
      end
    elsif reply_to_id = params[:reply_to_id]
      klass = resource_class == Freight ? LoadingSpace : Freight
      @reply_to = klass.find(reply_to_id)
      self.resource = resource_class.new
      @reply_to.attributes.each do |key, value|
        new_key = key =~ /^origin/ ? key.gsub('origin_', 'destination_') : key.gsub('destination_', 'origin_')
        resource[new_key] = value if resource.attributes.has_key?(new_key) && !%w(contact_person_id).include?(key)
      end
      self.resource.reply_to_id = @reply_to.id
    else
      self.resource = resource_class.new
      resource.contractor = current_company.name if resource.respond_to?(:contractor)
      resource.valid_until = Time.zone.now.midnight + 1.week if resource.respond_to?(:valid_until)
      resource.first_transport_at = Time.zone.now.midnight + 1.week if resource.respond_to?(:first_transport_at)
      resource.last_transport_at = Time.zone.now.midnight + 5.week if resource.respond_to?(:last_transport_at)
      resource.origin_side_track_available = true
      resource.destination_side_track_available = true
      resource.origin_date = Time.now.beginning_of_week + 1.week
      resource.destination_date = resource.origin_date + 1.month
      resource.hazmat = false
      #resource.origin_country = resource.destination_country = "Germany"
      resource.localized_infos.build
    end
  end
  
  def create
    self.resource = resource_class.new(params[resource_key])
    resource.user, resource.company = current_user, current_company
    create!
  end
  
  def index
    super do
      @uploaded = params[:uploaded]
      @highlight = @uploaded
      if @q
        @origin_city ||= collection.detect { |posting|
          posting.origin_city =~ /^#{@q}/i
        }.full?(&:origin_city)
        @destination_city ||= collection.detect { |posting|
          posting.destination_city =~ /^#{@q}/i
        }.full?(&:destination_city)
      end
    end
  end
  
  def update
    self.resource = resource_class.find(params[:id])
    resource.localized_infos = params[resource_key].delete(:localized_infos)
    resource.update_attributes(params[resource_key])
    if resource.valid?
      resource.save!
      redirect_to resource
    else
      render :action => :edit
    end
  end

  # TODO: write worker to parse postings in background?
  def upload
    if request.post?
      @sheet = Uploaded::Sheet.new(params[:data])
      @headers = headers_from_sheet(@sheet)
      @rows = extract_after(@sheet.rows, @headers)
      @posting_attributes = @rows.map do |row|
        Uploaded::Posting.new(row, @headers)
      end
      klass = Freight
      @collection = @posting_attributes.map do |posting|
        record = klass.new(posting.attributes.reverse_merge(:contractor => current_company.name, :desired_means_of_transport => 'custom'))
        record.user = current_user
        record.company = current_company
        record
      end
      @saved = @collection.select(&:save).map(&:id)
      redirect_to :controller => klass.to_s.underscore.pluralize, :company_id => current_company, :uploaded => @saved
    end
  end

  def show
    if can_see?(resource)
      show! {
        if recording_parent_id = params[:search_recording_id]
          opts = {:user_id => current_user.id, :parent_id => recording_parent_id, :result => resource}
          @search_recording = SearchRecording.create(opts)
        end
        page[:title] = t("#{controller_name}.show.page_title", :pretty_id => resource.pretty_id)
        record_action!(:read, resource)
        @resource_url = url_for(resource)

        if resource.parent
          @parents = []
          current_resource = resource
          while current_resource.parent
            diff = current_resource.attributes.diff(current_resource.parent.attributes)
            @parents << diff
            current_resource = current_resource.parent
          end
          @parents.reverse!
        end
      }
    else
      permission_denied!
    end
  end
  
  private

  def can_see?(posting, company = current_company)
    posting.company == company || (roles_ok?(posting, company) && reply_to_ok?(posting))
  end

  def reply_to_ok?(posting)
    reply_to_id = posting.reply_to_id
    reply_to_id.blank? || valid_reply_to_ids.include?(reply_to_id)
  end

  def roles_ok?(posting, company = current_company)
    if posting.company_roles.blank?
      if posting.custom_category.blank?
        true
      else
        posting.custom_category.full? == company.custom_category.full?
      end
    else
      # company must have all the roles specified in the posting
      if posting.company_roles.all? { |r| company.company_roles.include?(r) }
        # including the custom category
        if posting.custom_category.blank?
          true
        else
          posting.custom_category.full? == company.custom_category.full?
        end
      end
    end
  end

  def extract_after(rows, first_row)
    result = []
    first_row_found = false
    rows.each do |row|
      if first_row_found
        result << row unless row.first.blank?
      else
        first_row_found = true if row == first_row
      end
    end
    result
  end
  
  def filter_collection!
    # Do not show deleted postings
    self.collection = resource_class.scoped.where(:deleted => false).where("parent_id is NULL")

    # Default: newest postings first
    @blocked_ids = blocked_company_ids
    self.collection = collection.where("#{controller_name}.company_id NOT IN (?)", @blocked_ids) if @blocked_ids.full?
    self.collection = collection.order("#{controller_name}.created_at DESC")
    if @company_id = params[:company_id].full?
      @company = Company.find(@company_id)
      page[:title] = @company.name
      # TODO: blacklisting beachten?
      self.collection = collection.where(:company_id => @company_id)
    end

    # Do not show postings which start dates lie in the past
    if @company == current_company && params[:invalid]
      # show invalid
        self.collection = collection.where("valid_until < ?", Time.now)
    else
      self.collection = collection.where("valid_until >= ?", Time.now)
    end

    # Do not show :reply_to postings that do not belong to us
    self.collection = collection.where("company_id = ? OR reply_to_id IS NULL OR reply_to_id IN (?)", current_company.id, valid_reply_to_ids)

    # Do not show postings that the user should not see
    valid_ids = collection.select { |posting| can_see?(posting) }.map(&:id)
    self.collection = collection.where(:id => valid_ids)
  end
  
  def headers_from_sheet(sheet, attributes = Uploaded::Posting::ATTRIBUTES)
    sheet.rows.detect { |row| attributes.include?(row.first) }
  end
  
  def perform_search!
    super
    if @origin_city = params[:origin_city].full?
      # TODO: perform lookup via SQL
      matched_ids = collection.select { |posting| posting.origin_city == @origin_city }.map(&:id)
      self.collection = collection.where(:id => matched_ids)
    end
    if @destination_city = params[:destination_city].full?
      # TODO: perform lookup via SQL
      matched_ids = collection.select { |posting| posting.destination_city == @destination_city }.map(&:id)
      self.collection = collection.where(:id => matched_ids)
    end
    if @origin_station_id = params[:origin_station_id].full?
      self.collection = collection.where(:origin_station_id => @origin_station_id)
    end
    if @destination_station_id = params[:destination_station_id].full?
      self.collection = collection.where(:destination_station_id => @destination_station_id)
    end
  end

  def order_map
    super.merge(:default => :created_at)
  end

  def valid_reply_to_ids
    current_company.send(controller_name).map(&:id)
  end

end
