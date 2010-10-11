class Admin::BaseController < ApplicationController
  role_required :administrator
  
  def index
    redirect_to :controller => 'stations'
  end
end
