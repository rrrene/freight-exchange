class PostingsController < InheritedResources::Base
  login_required
  same_company_required :only => %w(edit update)
  ownership_required :only => %w(edit update)
end
