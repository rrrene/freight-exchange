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
      @postings = @rows.map do |row|
        Uploaded::Posting.new(row, @headers)
      end
    end
  end

  def show
    show! {
      if parent_id = params[:search_recording_id]
        opts = {:user_id => current_user.id, :parent_id => parent_id, :result => resource}
        @search_recording = SearchRecording.create(opts)
      end
      page[:title] = t("#{controller_name}.show.page_title", :pretty_id => resource.pretty_id)
      @resource_url = url_for(resource)
    }
  end
  
  private
  
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
    self.collection = resource_class.scoped.where(:deleted => false)
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

end
