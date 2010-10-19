class RemoteController < InheritedResources::Base
  remote_enabled
  login_required
end
