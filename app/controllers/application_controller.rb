class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :record_user_in_recordings
  helper_method :current_user, :demo_mode?, :page
  layout 'application'
  
  private
  
  # Returns the currently logged in user.
  def current_user
    @current_user ||= UserSession.find.full?(&:user)
  end
  
  # Returns whether or not the application is running in demo mode.
  def demo_mode?
    AppConfig[:demo_mode].full?
  end
  
  # Use this in a controller to restrict access.
  def self.login_required(opts = {})
    before_filter :require_user, opts
  end
  
  # Use this in a controller to restrict access to owners.
  def self.ensure_resource_belongs_to_user(opts = {})
    before_filter :require_owner, opts
  end
  
  def record_user_in_recordings
    #Recorder.always_save(:user_id, current_user.id) if current_user
    #Recorder.always_save(:record_updated_at, Proc.new { |ar| ar.updated_at })
  end
  
  def require_owner # :nodoc:
    if resource && current_user
      resource.user == current_user 
    end
  end
  
  def require_user # :nodoc:
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_url
      return false
    end
  end

  def require_no_user # :nodoc:
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to root_url
      return false
    end
  end
  
  def store_location # :nodoc:
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default) # :nodoc:
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  def page
    @page ||= {}
  end
  
end
