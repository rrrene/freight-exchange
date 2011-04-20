# The CompaniesController provides functionality for managing a user's company
# as well as the actual 'Create a new Account'-screen.
class CompaniesController < RemoteController
  login_required :except => [:new, :create]
  same_company_required :except => [:dashboard, :new, :create, :show, :postings]
  role_required :company_admin, :except => [:dashboard, :new, :create, :show, :postings]
  
  # The dashboard action provides a general overview of the company's 
  # activities.
  def dashboard
    @company = current_company
    @recordings = current_company.action_recordings.limit(50)
  end
  
  # The Companies#new action is actually the "Create a new Account"-screen
  # a user sees when he originally signs up for the freight exchange.
  def new
    @company = Company.new
    @user = User.new(:user_roles => [UserRole[:company_admin]])
    @user.build_person
  end
  
  def create
    @company = Company.new(params[:company])
    @user = User.new(params[:user])
    @company.valid? # to populate @company.errors
    if @user.valid? && @company.valid?
      @company.save!
      @user.company = @company
      @user.save!
      redirect_to after_login_url
    else
      render :action => :new
    end
  end
  
  def postings
    show! do
      @postings = @company.freights
    end
  end
  
end
