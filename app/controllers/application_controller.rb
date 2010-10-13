class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :login_by_api_key
  before_filter :record_user_in_recordings
  before_filter :set_default_page_title
  helper_method :current_user, :controller_catalog, :current_person, :current_company, :logged_in?, :demo_mode?, :page
  layout 'application'
  
  private
  
  # Returns the i18n catalog path for the current controller.
  # 
  #   class UsersController < ApplicationController
  #     def index
  #       controller_catalog # => 'users'
  #     end
  #   end
  #
  #   class Admin::UsersController < Admin::BaseController
  #     def index
  #       controller_catalog # => 'admin.users'
  #     end
  #   end
  #
  def controller_catalog # :doc:
    controller_path.gsub('/', '.')
  end
  
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
  
  # Logs the user in for this very request if an API key is provided in the params.
  def login_by_api_key
    if api_key = params[:api_key]
      if u = User.where(:api_key => api_key).first
        @current_user = u # login for this request only
      end
    end
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
  
  # Use this in a controller to restrict access to  
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
    unless current_user && (current_user.roles & allowed_roles).any?
      page[:title] = "Permission denied."
      render :text => "You tried to access a restricted area or function.", :layout => 'content_only'
      return false
    end
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
      respond_to do |format|
        format.html { redirect_to login_url }
        format.xml { render_errors(flash[:notice]) }
        format.json { render_errors(flash[:notice]) }
      end
      return false
    end
  end
  
  # Renders an array of error messages in the request format.
  def render_errors(*error_messages)
    render params[:format].intern => ErrorMessages.new(error_messages)
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
    page[:title] = t("#{controller_catalog}.#{action_name}.page_title")
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
