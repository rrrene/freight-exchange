class CompaniesController < InheritedResources::Base
  login_required
  same_company_required :except => [:show]
  role_required :company_admin, :except => [:show]
  
  def show
    redirect_to root_url # TODO: what to do here?
  end
  
end
