# The Admin::BaseController is the controller every other backend controller inherits
# from. He is mainly responsible for providing basic functionality to all controllers
# in the Admin module, e.g. rights management.
class Admin::BaseController < RemoteController
  role_required :administrator

  # overrides ApplicationController#contextual_search_controller
  def contextual_search_controller # :nodoc:
    if action_name != 'dashboard'
      if %w(app_configs companies freights loading_spaces stations users).include?(controller_name)
        return controller_name
      end
    end
    'search'
  end
end