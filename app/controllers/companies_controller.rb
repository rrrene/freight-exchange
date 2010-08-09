class CompaniesController < InheritedResources::Base
  ensure_resource_belongs_to_user :only => %w(edit update)
  
  def show
    redirect_to root_url # TODO: what to do here?
  end
  
end
