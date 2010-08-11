class UsersController < ApplicationController
  #before_filter :require_no_user, :only => [:new, :create]
  login_required :only => [:show, :edit, :update]
  same_company_required :only => [:show, :edit, :update]
  role_or_ownership_required :company_admin, :only => [:edit, :update]
  
  def new
    @company = Company.new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to after_login_url
    else
      render :action => :new
    end
  end
  
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to users_url
    else
      render :action => :edit
    end
  end
end
