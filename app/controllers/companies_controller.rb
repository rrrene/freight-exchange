class CompaniesController < InheritedResources::Base
  login_required
  role_or_ownership_required [:company_admin, :administrator], :except => [:show]
  
  def show
    redirect_to root_url # TODO: what to do here?
  end
  
end
