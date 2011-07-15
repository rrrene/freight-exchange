# The PostingsController provides functionality for creating and editing 
# postings (freights and loading_spaces).
#
# Both the FreightsController and the LoadingSpacesController inherit from here.
#

require_dependency 'uploaded_sheet' if Rails.env == 'development'

class PostingsController < RemoteController
  same_company_required :only => %w(edit update destroy)
  role_required [:company_admin, :company_employee], :only => [:new, :create, :edit, :update, :destroy]
  
  def new
    if parent = params[:parent_id].full? { |id| resource_class.find(id) }
      self.resource = resource_class.new(parent.attributes.clone)
      parent.localized_infos.each do |li|
        resource.localized_infos.build(li.attributes)
      end
    else
      self.resource = resource_class.new
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

  def upload
    if request.post?
      @sheet = UploadedSheet.new(params[:data])
      # TODO: write worker to parse postings in background?
      @sheet.rows.each do |row|
        # ...
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
    }
  end
  
  private
  
  def filter_collection!
    # Do not show deleted postings
    self.collection = resource_class.scoped.where(:deleted => false)
    # Do not show postings which start dates lie in the past
    self.collection = collection.where("origin_date > ?", Time.now)

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
  end

  def order_map
    super.merge(:default => :created_at)
  end

end
