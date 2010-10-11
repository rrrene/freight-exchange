class RootController < ApplicationController
  login_required :only => [:welcome]
  
  def about
    page[:title] = t("root.about.page_title")
  end
  
  # 
  def index
    if just_set_up?
      unless just_set_up_but_not_seeded?
        # db is seeded properly, now we need to create an admin account
        # => SetupController
        #     Login & Passwort ändern
        admin = create_admin!
        UserSession.login(admin)
        AppConfig[:just_set_up] = false
        redirect_to edit_user_url(admin)
      else
        # db has to be seeded to proceed
        render :text => 'Run `rake db:seed` and restart your server!', :layout => true        
      end
    end
  end
  
  # This action decides what to do with a freshly logged in user.
  def welcome
    if current_user.company.blank?
      redirect_to new_company_url
    else
      redirect_to company_dashboard_url
    end
  end
  
  private
  
  def admin_user_attributes
    {
      :login => 'admin',
      :email => 'admin@example.org',
      :password => 'admin', 
      :password_confirmation => 'admin',
      :person_attributes => {
        :gender => 'male',
        :first_name => 'Max',
        :last_name => 'Power'
      },
      :company_attributes => {
        :name => 'Freight Exchange',
      }
    }
  end
  
  def create_admin!
    admin = User.new(admin_user_attributes)
    admin = admin.save ? admin : User.where(:login => admin_user_attributes[:login]).first
    admin.user_roles << UserRole[:administrator]
    admin
  end
  
  def just_set_up?
    AppConfig[:just_set_up] == true
  end
  
  def just_set_up_but_not_seeded?
    Country.count == 0
  end
  
end
