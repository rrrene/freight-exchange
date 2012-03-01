class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :record_user_in_recordings
  before_filter :set_locale
  before_filter :set_default_page_title
  helper_method :current_user, :controller_catalog, :current_person, :current_company, :logged_in?, :demo_mode?, :page
  helper_method :black_listed?, :white_listed?
  helper_method :contextual_search_controller
  helper_method :auto_link_pretty_map
  layout 'application'
  
  private
  
  def auto_link_pretty_map
    @auto_link_pretty_map ||= {
      Freight => %w(FR NF N),
      LoadingSpace => %w(LS AN A),
      Review => %w(RE BW),
    }.inject({}) do |hsh, (key, value)|
      value.each { |str| hsh[str] = key }
      hsh
    end
  end

  def black_listed?(record)
    current_company.black_listed?(record)
  end

  def white_listed?(record)
    current_company.white_listed?(record)
  end

  def blocked_company_ids
    current_company.black_listed_items.where(:item_type => 'Company').collect(&:item_id)
  end

  def contextual_search_controller
    if action_name != 'dashboard'
      if %w(companies freights loading_spaces stations).include?(controller_name)
        return controller_name
      end
    end
    'freights'
  end

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
  def controller_catalog() # :doc:
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
    @current_user ||= begin
      if api_request?
         UserSession.find.full?(&:user) ||
          authenticate_by_api_key_in_params || 
            authenticate_by_api_key_in_http_auth
      else
        UserSession.find.full?(&:user)
      end
    end
  end
  
  def logged_in?
    current_user.present?
  end
  
  # Returns <tt>true</tt> if the application is running in demo mode.
  def demo_mode?() # :doc:
    AppConfig[:demo_mode].full?
  end
  
  # Returns <tt>true</tt> if the application was just set up.
  def just_set_up?
    AppConfig[:just_set_up] == true
  end
  
  # Saves an AppConfig, that the application was just set up.
  def just_set_up!
    AppConfig[:just_set_up] = false
  end
  
  def api_request?
    [Mime::XML, Mime::JSON].include?(request.format)
  end
  
  # Logs the user in for this very request if an API key is provided via http_auth.
  def authenticate_by_api_key_in_http_auth
    authenticate_or_request_with_http_basic do |api_key, _|
      return User.where(:api_key => api_key).first
    end
    nil
  end
  
  # Logs the user in for this very request if an API key is provided in the params.
  def authenticate_by_api_key_in_params
    if api_key = params[:api_key]
      User.where(:api_key => api_key).first
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
      require_owner or require_role(allowed_role_names)
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
  
  def permission_denied!
    page[:title] = "Permission denied."
    render :text => "You tried to access a restricted area or function.", :layout => true, :status => 401
    return false
  end
  
  def record_action!(action, record)
    opts = record_user_in_recordings || {}
    ActionRecording.create!({:action => action.to_s, :item => record}.merge(opts))
  end
  
  def record_user_in_recordings
    if logged_in?
      GeneralObserver.always_save(:user_id, current_user.id)
      GeneralObserver.always_save(:company_id, current_company.id)
      GeneralObserver.additional_attributes
    end
  end
  
  def require_owner
    if resource && current_user
      resource.user == current_user
    end
  end
  
  def require_role(allowed_roles = [])
    return if controller_name == "setup" && %w(index not_seeded).include?(action_name)
    unless current_user && (current_user.roles & allowed_roles).any?
      permission_denied!
    end
  end
  
  def require_same_company
    granted = if resource && current_user
      if resource.respond_to?(:company)
        current_user.company == resource.company
      elsif resource.respond_to?(:user)
        current_user.company == resource.user.company
      else
        false
      end
    else
      false
    end
    return permission_denied! unless granted
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

  def set_locale
    locale = current_person.try(:locale) || I18n.default_locale
    locale = session[:locale] = (params[:locale] || session[:locale] || locale).to_s.intern
    if I18n.available_locales.include?(locale)
      I18n.locale = locale
    end
  end

  def store_location
    session[:return_to] = request.fullpath
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  def page
    @page ||= {}
  end  
end
