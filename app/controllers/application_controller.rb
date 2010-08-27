class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :record_user_in_recordings
  before_filter :set_default_page_title
  helper_method :current_user, :current_person, :current_company, :logged_in?, :demo_mode?, :page
  layout 'application'
  
  private
  
  # Returns the Company object of the currently logged in user or <tt>nil</tt> if no user is logged in.
  def current_company() # :doc:
    current_user.full?(&:company)
  end
  
  # Returns the Person object of the currently logged in user or <tt>nil</tt> if no user is logged in.
  def current_person() # :doc:
    if current_user
      current_user.person || current_user.build_person
    end
  end
  
  # Returns the User object of the currently logged in user or <tt>nil</tt> if no user is logged in.
  def current_user() # :doc:
    @current_user ||= UserSession.find.full?(&:user)
  end
  alias logged_in? current_user
  
  # Returns <tt>true</tt> if the application is running in demo mode.
  def demo_mode?() # :doc:
    AppConfig[:demo_mode].full?
  end
  
  # Use this in a controller to restrict access.
  # 
  #   class UsersController < ApplicationController
  #     login_required :only => [:edit, :update, :show]
  #   end
  #
  def self.login_required(opts = {}) # :doc:
    before_filter :require_user, opts
  end
  
  # Use this in a controller to restrict access to owners.
  def self.ownership_required(opts = {}) # :doc:
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
  def self.role_or_ownership_required(roles, opts = {}) # :doc:
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
  def self.role_required(roles, opts = {}) # :doc:
    allowed_role_names = [roles].flatten.map(&:to_s)
    before_filter(opts) do |controller|
      require_role(allowed_role_names)
    end
  end
  
  def self.same_company_required(opts = {}) # :doc:
    before_filter :require_same_company, opts
  end
  
  def record_user_in_recordings
    if logged_in?
      GeneralObserver.always_save(:user_id, current_user.id)
      GeneralObserver.always_save(:company_id, current_company.id)
    end
  end
  
  def require_owner
    if resource && current_user
      resource.user == current_user
    end
  end
  
  def require_role(allowed_roles = [])
    current_user && (current_user.roles & allowed_roles).any?
  end
  
  def require_same_company
    if resource && current_user
      if resource.respond_to?(:company)
        current_user.company == resource.company
      elsif resource.respond_to?(:user)
        current_user.company == resource.user.company
      else
        false
      end
    end
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
  
  def set_default_page_title
    page[:title] = t("#{controller_name}.#{action_name}.page_title")
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  def page
    @page ||= {}
  end
  
end
