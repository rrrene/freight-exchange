class SearchController < ApplicationController
  login_required
  
  def index
    @results = Search.find(params[:q])
    @station_results = Search.find(params[:q], [Station])
  end
  
end
