# The GeneralObserver inherits Recorder::Observer to provide basic recording 
# functionality.
#
# It watches all user editable models in the app.
class GeneralObserver < Recorder::Observer
  USER_EDITABLE_MODELS = [:user, :person, :company, :freight, :loading_space, :review]
  ADMIN_EDITABLE_MODELS = [:app_config, :user_role]
  
  IGNORE_TIMESTAMPS = [:updated_at, :created_at, :last_request_at, :current_login_at, :last_login_at]
  IGNORE_TOKENS = [:single_access_token, :perishable_token, :persistence_token]
  IGNORE_USER_FIELDS = [:crypted_password, :password_salt] #, :login_count, :failed_login_count
  
  recording_class :action_recording
  observe USER_EDITABLE_MODELS + ADMIN_EDITABLE_MODELS
  ignore IGNORE_TIMESTAMPS + IGNORE_TOKENS + IGNORE_USER_FIELDS
end
