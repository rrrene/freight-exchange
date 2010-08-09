class SearchController < ApplicationController
  login_required
  
  def index
    q = params[:q]
    @results = {
      :main => Search.find(q)
    }
    @sidebar_result_models = %w(company station)
    @sidebar_result_models.each do |klass|
      @results[klass] = Search.find(q, [klass.classify])
    end
  end
  
end
