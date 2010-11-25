class PostingsController < RemoteController
  same_company_required :only => %w(edit update)
  role_required [:company_admin, :company_employee], :only => [:new, :create, :edit, :update]
  
  def new
    if parent = params[:parent_id].full? { |id| resource_class.find(id) }
      self.resource = parent
    else
      self.resource = resource_class.new(:hazmat => true, :weight => 1000, :loading_meter => 10)
      resource.build_origin_site_info({:contractor => current_company.name, :date => Time.new,
          :name => 'Bochum Hbf', :side_track_available => false,
          :address => 'Bahnhofstr. 56', :zip => '44789', :city => 'Bochum', :country => 'Germany',
        })
      resource.build_destination_site_info({:date => Time.new,
            :contractor => 'RWE Essen', :name => 'Essen Hbf', :side_track_available => true,
            :track_number => '16-A',
            :address => 'Kennedystr. 56', :zip => '45243', :city => 'Essen', :country => 'Germany',
      })
      resource.localized_infos.build
    end
  end
  
  def create
    self.resource = resource_class.new(params[resource_key])
    resource.user, resource.company = current_user, current_company
    create!
  end
  
  def index
    self.collection = resource_class.where(:company_id => current_company.id)
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
  
  def collection=(val)
    instance_variable_set("@#{collection_name}", val)
  end
  
  def collection_name
    instance_name.pluralize
  end
  
  def instance_name
    controller_name.classify.underscore
  end
  alias resource_key instance_name
  
  def resource=(val)
    instance_variable_set("@#{instance_name}", val)
  end
  
end
