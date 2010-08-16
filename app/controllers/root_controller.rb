class RootController < ApplicationController
  login_required :only => [:welcome]
  
  def about
    page[:title] = t("root.about.page_title")
  end
  
  def index
  end
  
  # This action decides what to do with a freshly logged in user.
  def welcome
    if current_user.company.blank?
      redirect_to new_company_url
    else
      redirect_to company_dashboard_url
    end
  end

end
