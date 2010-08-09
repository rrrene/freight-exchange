class PostingsController < InheritedResources::Base
  login_required
  ensure_resource_belongs_to_user :only => %w(edit update)
end
