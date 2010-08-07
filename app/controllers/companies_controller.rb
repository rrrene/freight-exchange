class CompaniesController < ApplicationController
  login_required
  
  def edit
    set_standard_record
  end
  
  def update
    perform_standard_update
  end
  
  def show
    redirect_to root_url # TODO: what to do here?
  end
  
end
