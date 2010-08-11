class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :record_user_in_recordings
  before_filter :set_default_page_title
  helper_method :current_user, :logged_in?, :demo_mode?, :page
  layout 'application'
  
  private
  
  # Returns the currently logged in user.
  def current_user
    @current_user ||= UserSession.find.full?(&:user)
  end
  alias logged_in? current_user
  
  # Returns whether or not the application is running in demo mode.
  def demo_mode?
    AppConfig[:demo_mode].full?
  end
  
  # Use this in a controller to restrict access.
  def self.login_required(opts = {})
    before_filter :require_user, opts
  end
  
  # Use this in a controller to restrict access to owners.
  def self.ownership_required(opts = {})
    before_filter :require_owner, opts
  end
  
  # Use this in a controller to restrict access to either 
  # users of certain roles (e.g. admins) or the rightful owner
  # of an object.
  #
  #   class PostingController < ApplicationController
  #     role_or_ownership_required [:posting_admin, :administrator]
  #   end
  #
  def self.role_or_ownership_required(roles, opts = {})
    allowed_role_names = [roles].flatten.map(&:to_s)
    before_filter(opts) do |controller|
      require_role(allowed_role_names) or require_owner
    end
  end
  
  # Use this in a controller to restrict access to either 
  # users of certain roles (e.g. admins).
  #
  #   class Admin::BaseController < ApplicationController
  #     role_required :administrator
  #   end
  #
  def self.role_required(roles, opts = {})
    allowed_role_names = [roles].flatten.map(&:to_s)
    before_filter(opts) do |controller|
      require_role(allowed_role_names)
    end
  end
  
  def self.same_company_required(opts = {})
    before_filter :require_same_company, opts
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
  
  def require_role(allowed_roles = []) # :nodoc:
    current_user && (current_user.roles & allowed_roles).any?
  end
  
  def require_same_company # :nodoc:
    if resource && current_user
      if resource.respond_to?(:company)
        current_user.company == resource.company
      elsif resource.respond_to?(:user)
        current_user.company == resource.user.company
      elsif resource.is_a?(Company)
        current_user.company == resource
      else
        false
      end
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
  
  def set_default_page_title # :nodoc:
    page[:title] = t("#{controller_name}.#{action_name}.page_title")
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
