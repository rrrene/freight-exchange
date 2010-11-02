class SetupController < ApplicationController
  before_filter :require_just_set_up
  
  def index
    unless just_set_up_but_not_seeded?
      # db is seeded properly, now we need to create an admin account
      # => SetupController
      #     Login & Passwort ändern
      admin = create_admin!
      UserSession.login(admin)
      just_set_up!
    else
      # db has to be seeded to proceed
      redirect_to :action => 'not_seeded'  
    end
  end

  def not_seeded
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
  
  def just_set_up_but_not_seeded?
    Country.count == 0
  end
  
  def require_just_set_up
    unless just_set_up?
      permission_denied!
    end
  end
  
end
