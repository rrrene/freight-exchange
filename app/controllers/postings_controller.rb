# The PostingsController provides functionality for creating and editing 
# postings (freights and loading_spaces).
#
# Both the FreightsController and the LoadingSpacesController inherit from here.
# 
class PostingsController < RemoteController
  same_company_required :only => %w(edit update destroy)
  role_required [:company_admin, :company_employee], :only => [:new, :create, :edit, :update, :destroy]
  
  def new
    if parent = params[:parent_id].full? { |id| resource_class.find(id) }
      self.resource = resource_class.new(parent.attributes.clone)
      resource.build_origin_site_info(parent.origin_site_info.attributes)
      resource.build_destination_site_info(parent.destination_site_info.attributes)
      parent.localized_infos.each do |li|
        resource.localized_infos.build(li.attributes)
      end
    else
      self.resource = resource_class.new
      resource.build_origin_site_info(:contractor => current_company.name)
      resource.build_destination_site_info
      resource.localized_infos.build
    end
  end
  
  def create
    self.resource = resource_class.new(params[resource_key])
    resource.user, resource.company = current_user, current_company
    create!
  end
  
  def index
    # Do not show deleted postings
    self.collection = resource_class.scoped.where(:deleted => false)
    # Do not show postings which start dates lie in the past
    self.collection = collection.includes(:origin_site_info).where("site_infos.date > ?", Time.now)
    
    filter_collection!

    @count = resource_class.count
    index!
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
  
  def show
    show! {
      if parent_id = params[:search_recording_id]
        opts = {:user_id => current_user.id, :parent_id => parent_id, :result => resource}
        @search_recording = SearchRecording.create(opts)
      end
    }
  end
  
  private
  
  def filter_collection!
    # Default: newest postings first
    self.collection = collection.order("#{controller_name}.created_at DESC")
  end
    
end
