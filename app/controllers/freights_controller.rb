class FreightsController < InheritedResources::Base
  login_required
  same_company_required :only => %w(edit update)
  role_required [:company_admin, :company_employee], :only => [:new, :create, :edit, :update]
  
  def new
    @freight = Freight.new(:hazmat => true, :weight => 1000)
    @freight.build_origin_site_info({:contractor => current_company.name, :date => Time.new,
        :name => 'Bochum Hbf', :side_track_avaiable => false,
        :address => 'Bahnhofstr. 56', :zip => '44789', :city => 'Bochum', :country => 'Germany',
      })
    @freight.build_destination_site_info({:date => Time.new,
          :contractor => 'RWE Essen', :name => 'Essen Hbf', :side_track_avaiable => true,
          :track_number => '16-A',
          :address => 'Kennedystr. 56', :zip => '45243', :city => 'Essen', :country => 'Germany',
    })
    @freight.localized_infos.build
  end
  
  def create
    @freight = Freight.new(params[:freight])
    @freight.user, @freight.company = current_user, current_company
    if @freight.valid?
      @freight.save!
      redirect_to @freight
    else
      render :action => :new
    end
  end
  
  def update
    @freight = Freight.find(params[:id])
    @freight.localized_infos = params[:freight].delete(:localized_infos)
    @freight.update_attributes(params[:freight])
    if @freight.valid?
      @freight.save!
      @freight.update_localized_infos
      redirect_to @freight
    else
      render :action => :edit
    end
  end
  
end
