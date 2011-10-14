# The UserSessionsController provides basic session-management functionality.
#
# Basically that means logging users in and out.
class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create, :forgot_password]
  before_filter :require_user, :only => :destroy
  #layout 'content_only'
  
  # This action is only available if the application is running in demo mode.
  # It creates a UserSession for a given user without any further authentication.
  def demo_login
    if demo_mode?
      @user = User.find(params[:id])
      if UserSession.login(@user)
        record_action!(:demo_login, current_user)
        redirect_to after_login_url
      else
        render :action => :new
      end
    end
  end
  
  # Authenticates a User by creating and saving a UserSession.
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      record_action!(:login, current_user)
      flash[:notice] = "Login successful!"
      redirect_back_or_default after_login_url
    else
      @failed = true
      render :action => :new
    end
  end
  
  def forgot_password
    if request.post?
      str = params[:user_session][:email].to_s.upcase
      if @user = User.where("UPPER(email) = ? OR UPPER(login) = ?", str, str).first
        if @password = @user.reset_password!
          record_action!(:password_reset, current_user)
          # changing the password seems to save a UserSession 
          # and logs the given user in
          UserSession.find.destroy
          UserNotifier.forgot_password(@user, @password).deliver
          @success = true
        end
      end
      @failed = @password.blank?
    end
  end
  
  # this is kind of a bugfix:
  # after an unsuccessful POST to index (#create),
  # a reload caused a 'no such action' error 
  # (because it's a GET request now)
  def index
    render :action => :new
  end
  
  # Logs a user out.
  def destroy
    UserSession.find.destroy
      record_action!(:logout, current_user)
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end
end
