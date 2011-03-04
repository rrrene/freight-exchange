# The RootController is the starting point of the application.
#
# On first start, it creates an admin user and guides him to the setup process.
# On login, it redirects users to their designated location.
#
# Additionally, the RootController also holds information about the app 
# (e.g. the about action).
class RootController < ApplicationController
  # The index action decides where the current_user is redirected
  # based on whether or not the app is already set up.
  def index
    if just_set_up?
      redirect_to setup_path
    else
      redirect_to :action => 'welcome'
    end
  end
  
  # The welcome action decides what to do with a freshly logged in user.
  def welcome
    if logged_in?
      if current_user.company.blank?
        redirect_to new_company_url
      else
        redirect_to company_dashboard_url
      end
    else
      #render :layout => 'content_only'
    end
  end
  
end
