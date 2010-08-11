class UsersController < ApplicationController
  #before_filter :require_no_user, :only => [:new, :create]
  login_required :only => [:show, :edit, :update]
  same_company_required :only => [:show, :edit, :update]
  role_or_ownership_required :company_admin, :only => [:show, :edit, :update]
  
  def index
    redirect_to root_url
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_back_or_default users_url
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
    @user = current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to users_url
    else
      render :action => :edit
    end
  end
end
