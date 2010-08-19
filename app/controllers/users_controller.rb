class UsersController < InheritedResources::Base
  login_required
  same_company_required :only => [:edit, :update]
  role_or_ownership_required :company_admin, :only => [:edit, :update]
  role_required :company_admin, :only => [:index, :new, :create]
  
  # Lists all users in the current company.
  def index
    @users = current_company.users
  end
  
  # This creates a new user inside the current company.
  # For the original sign up screen, see Companies#new.
  def create
    @user = User.new(params[:user])
    @user.company = current_company
    if @user.save
      redirect_to :action => :index
    else
      render :action => :new
    end
  end
  
  def show # :nodoc:
    show! {
      page[:title] = @user.name
    }
  end
  
end
