# The PeopleController provides basic functionality for editing People objects,
# i.e. personal information of a User object.
class PeopleController < InheritedResources::Base
  login_required
  same_company_required :only => [:edit, :update]
  role_or_ownership_required :company_admin, :only => [:edit, :update]
  role_required :company_admin, :only => [:index, :new, :create]
end
