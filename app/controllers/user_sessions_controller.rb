# The UserSessionsController provides basic session-management functionality.
#
# Basically that means logging users in and out.
class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  layout 'content_only'
  
  # This action is only available if the application is running in demo mode.
  # It creates a UserSession for a given user without any authentication.
  def demo_login
    if demo_mode?
      @user = User.find(params[:id])
      if UserSession.login(@user)
        redirect_to after_login_url
      else
        render :action => :new
      end
    end
  end
  
  def new
    @user_session = UserSession.new
  end
  
  # Authenticates a User by creating and saving a UserSession.
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default after_login_url
    else
      render :action => :new
    end
  end
  
  # Logs a user out.
  def destroy
    UserSession.find.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end
end
