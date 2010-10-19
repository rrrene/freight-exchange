class LoadingSpacesController < RemoteController
  same_company_required :only => %w(edit update)
  role_required [:company_admin, :company_employee], :only => [:new, :create, :edit, :update]
  
  def new
    @loading_space = resource_class.new(:hazmat => true, :weight => 1000)
    @loading_space.build_origin_site_info({:contractor => current_company.name, :date => Time.new,
        :name => 'Bochum Hbf', :side_track_available => false,
        :address => 'Bahnhofstr. 56', :zip => '44789', :city => 'Bochum', :country => 'Germany',
      })
    @loading_space.build_destination_site_info({:date => Time.new,
          :contractor => 'RWE Essen', :name => 'Essen Hbf', :side_track_available => true,
          :track_number => '16-A',
          :address => 'Kennedystr. 56', :zip => '45243', :city => 'Essen', :country => 'Germany',
    })
    @loading_space.localized_infos.build
  end
  
  def create
    @loading_space = resource_class.new(params[:loading_space])
    @loading_space.user, @loading_space.company = current_user, current_company
    create!
  end
  
  def update
    @loading_space = resource_class.find(params[:id])
    @loading_space.localized_infos = params[:loading_space].delete(:localized_infos)
    @loading_space.update_attributes(params[:loading_space])
    if @loading_space.valid?
      @loading_space.save!
      @loading_space.update_localized_infos
      redirect_to @loading_space
    else
      render :action => :edit
    end
  end
  
end
