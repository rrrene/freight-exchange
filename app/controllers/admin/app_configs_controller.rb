# The Admin::AppConfigsController provides functionality for managing all 
# system-wide settings in the app, e.g. main language or demo-mode, via the 
# backend.
#
# NOTE: Although not listed, basic functions new, create, edit, update, 
# delete and index are provided via inheritance from Admin::BaseController.
#
class Admin::AppConfigsController < Admin::BaseController
  
  def reimport_defaults
    APP_CONFIG_DEFAULTS.each do |key, value|
      AppConfig[key] = value
    end
    flash[:notice] = "Done."
    redirect_to :action => :index
  end
  
end
