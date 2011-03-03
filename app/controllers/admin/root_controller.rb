class Admin::RootController < ApplicationController
  def index
    redirect_to :controller => '/setup', :action => 'index'
  end
end
