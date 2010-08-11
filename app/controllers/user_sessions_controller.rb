class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def demo_login
    if demo_mode?
      @user = User.find(params[:id])
      if UserSession.login(@user)
        flash[:notice] = "Login successful!"
        redirect_back_or_default after_login_url
      else
        render :action => :new
      end
    end
  end
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default after_login_url
    else
      render :action => :new
    end
  end
  
  def destroy
    UserSession.find.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end
end
