# The UsersController provides functionality for creating and editing 
# users in companies.
#
# 
class UsersController < RemoteController
  same_company_required :only => [:edit, :update]
  role_or_ownership_required :company_admin, :only => [:edit, :update]
  role_required :company_admin, :only => [:index, :new, :create]
  
  # Lists all users in the current company.
  def index
    index! {
      @users = current_company.users
    }
  end
  
  def new
    new! {
      if @parent = params[:parent_id].full? { |id| resource_class.find(id) }
        @user.build_person(@parent.person.attributes)
        %w(login email posting_type).each do |attr|
          @user[attr] = @parent[attr]
        end
        @user.user_roles = @parent.user_roles
      else
        @user.build_person
      end
    }
  end
  
  # This creates a new user inside the current company.
  # For the original sign up screen, see Companies#new.
  def create
    @user = User.new(params[:user])
    @user.company = current_company
    create!
  end
  
  def update
    save_roles = @user.user_roles & UserRole.backend_roles
    update! {
      save_roles.each { |r| @user.user_roles << r }
      @user
    }
  end
  
end
