class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :record_user_in_recordings
  helper_method :current_user
  layout 'application'

  private

  def current_user
    @current_user ||= UserSession.find.full?(&:user)
  end
  
  def self.login_required(opts = {})
    before_filter :require_user, opts
  end
  
  def record_user_in_recordings
    #Recorder.always_save(:user_id, current_user.id) if current_user
  end
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to root_url
      return false
    end
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end
