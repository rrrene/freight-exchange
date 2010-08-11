class CompaniesController < InheritedResources::Base
  login_required :except => [:new, :create]
  same_company_required :except => [:new, :create, :show]
  role_required :company_admin, :except => [:new, :create, :show]
  
  def new
    @company = Company.new
    @user = User.new
  end
  
  def create
    @company = Company.new(params[:company])
    @user = User.new(params[:user])
    @company.valid? # to fill @company.errors
    if @user.valid? && @company.valid?
      @company.save!
      @user.company = @company
      @user.save!
      redirect_to after_login_url
    else
      render :action => :new
    end
  end
  
  def show
    redirect_to root_url # TODO: what to do here?
  end
  
end
