class SetupController < Admin::BaseController
  def demo_company
    @company = Demo::Company.instance
    if params[:create]
      @company = Demo::Company.setup
    elsif params[:create_freights]
      Demo::Company.create_postings
    elsif params[:destroy] && @company
      @company.destroy
      @company = nil
    end
  end
  
  def index
    if just_set_up_but_not_seeded?
      # db has to be seeded to proceed
      redirect_to :action => 'not_seeded'
    else  
      if just_set_up?
        # db is seeded properly, now we need to create an admin account
        admin = create_admin!
        UserSession.login(admin)
        set_locale
        just_set_up!
      end
    end
  end
  
  def not_seeded
    if just_set_up? && just_set_up_but_not_seeded?
      render :layout => false
    else
      redirect_to :action => :index
    end
  end
  
  def redirect
    if current_user.is?(:marketing)
      redirect_to :controller => '/admin/users', :action => 'index', :filter => :created_at
    else
      redirect_to :controller => '/setup', :action => 'index'
    end
  end
  
  def tolk_import
    Tolk::Locale.sync!
    Tolk::Locale.import_secondary_locales
    flash[:tolk] = "Imported all secondary languages! (none :#{Tolk::Locale.primary_locale.name} locales)"
    redirect_to :action => :index
  end
  
  def tolk_dump_all
    Tolk::Locale.dump_all
    flash[:tolk] = "Dumped all!"
    redirect_to :action => :index
  end
  
  def tolk_sync
    Tolk::Locale.sync!
    flash[:tolk] = "Synced!"
    redirect_to :action => :index
  end

  
  private
  
  def admin_user_attributes
    {
      :login => 'admin',
      :email => 'admin@example.org',
      :password => user_pwd,
      :password_confirmation => user_pwd,
      :person_attributes => {
        :gender => 'male',
        :first_name => 'Max',
        :last_name => 'Power',
        :locale => 'de',
      },
      :company_attributes => {
        :name => 'Freight Exchange Service Provider',
      }
    }
  end
  
  def create_admin!
    admin = create_or_find(admin_user_attributes)
    admin.user_roles << UserRole[:administrator]
    admin
  end

  def create_or_find(attributes = {})
    user = User.new(attributes)
    if user.save 
      user
    else
      ::User.where(:login => user.login).first
    end
  end

  def just_set_up_but_not_seeded?
    UserRole.count == 0
  end
  
  def user_pwd
    "admin"
  end
  
end