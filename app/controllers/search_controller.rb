class SearchController < ApplicationController
  login_required
  
  def index
    @results = SimpleSearch / params[:q]
    @station_results = SimpleSearch.search(params[:q], :model => Station)
  end
  
end
