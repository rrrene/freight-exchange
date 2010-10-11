class Admin::BaseController < InheritedResources::Base
  role_required :administrator
end
