class SetupController < Admin::BaseController
  def demo_company
    @company = Company.where(:name => demo_company_attributes[:name]).first
    if params[:create]
      @company = create_demo_company!
    elsif params[:destroy]
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
  
  def tolk_import
    Tolk::Locale.sync!
    Tolk::Locale.import_secondary_locales
    flash[:tolk] = "Improted all secondary languages! (none #{Tolk::Locale.primary_locale} locales)"
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
        :last_name => 'Power'
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
  
  def create_demo_company!
    company = Company.where(:name => demo_company_attributes[:name]).first
    company ||= Company.create(demo_company_attributes)
    demo_user_attributes.each do |attr|
      create_or_find(attr.merge(:company_id => company.id))
    end
    if company_admin = company.users.first
      company_admin.user_roles << UserRole[:company_admin]
    end
    company
  end
  
  def demo_company_attributes
    {
      :name => "Demontage Sprenkler AG",
      :address => "Wallstr. 56-58",
      :zip => "44567",
      :city => "Bochum",
      :country => 'Deutschland',
      :phone => '+49 (0) 234 569986-0',
      :fax => '+49 (0) 234 569986-55',
      :email => 'demontage@example.org',
      :website => 'example.org',
    }
  end
  
  def demo_user_attributes
    [
      {
        :login => 'demo_user',
        :email => 'm.sprenkler@example.org',
        :password => user_pwd,
        :password_confirmation => user_pwd,
        :person_attributes => {
          :gender => 'male',
          :first_name => 'Maximilian',
          :last_name => 'Sprenkler',
          :job_description => 'Chief Executive Officer',
          :phone => '+49 (0) 234 569986-1',
          :fax => '+49 (0) 234 569986-55',
          :website => 'example.org/team/m.sprenkler',
        },
      },
      {
        :login => 'demo_user2',
        :email => 'b.sprenkler@example.org',
        :password => user_pwd,
        :password_confirmation => user_pwd,
        :person_attributes => {
          :gender => 'female',
          :first_name => 'Bettina',
          :last_name => 'Sprenkler',
          :job_description => 'Chief Financial Officer',
          :phone => '+49 (0) 234 569986-2',
          :fax => '+49 (0) 234 569986-55',
          :website => 'example.org/team/b.sprenkler',
        },
      },
      {
        :login => 'demo_user3',
        :email => 'p.krause@example.org',
        :password => user_pwd,
        :password_confirmation => user_pwd,
        :person_attributes => {
          :gender => 'male',
          :first_name => 'Peter',
          :last_name => 'Krause',
          :job_description => 'Senior Logistics Manager',
          :phone => '+49 (0) 234 569986-3',
          :fax => '+49 (0) 234 569986-55',
          :website => 'example.org/team/p.krause',
        },
      },
      {
        :login => 'demo_user4',
        :email => 'm.kowalla@example.org',
        :password => user_pwd,
        :password_confirmation => user_pwd,
        :person_attributes => {
          :gender => 'male',
          :first_name => 'Martin',
          :last_name => 'Kowalla',
          :job_description => 'Senior Logistics Manager',
          :phone => '+49 (0) 234 569986-4',
          :fax => '+49 (0) 234 569986-55',
          :website => 'example.org/team/m.kowalla',
        },
      },
      {
        :login => 'demo_user5',
        :email => 'a.baumann@example.org',
        :password => user_pwd,
        :password_confirmation => user_pwd,
        :person_attributes => {
          :gender => 'female',
          :first_name => 'Anette',
          :last_name => 'Baumann',
          :job_description => 'Logistics Trainee',
          :phone => '+49 (0) 234 569986-5',
          :fax => '+49 (0) 234 569986-55',
          :website => 'example.org/team/a.baumann',
        },
      },
    ]
  end
  
  def just_set_up_but_not_seeded?
    UserRole.count == 0
  end
  
  def create_or_find(attributes = {})
    user = User.new(attributes)
    if user.save 
      user
    else
      User.where(:login => user.login).first
    end
  end
  
  def user_pwd
    'admin'
  end
end