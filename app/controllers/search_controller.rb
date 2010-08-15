class SearchController < ApplicationController
  login_required
  
  def index
    @sidebar_result_models = %w(company station)
    @results = {}
    if @q = params[:q].full?
      @results[:main] = Search.find(@q, ['LoadingSpace', 'Freight'])
      @results[:count] = Search.count(@q, ['LoadingSpace', 'Freight'])
      @sidebar_result_models.each do |klass|
        @results[klass] = Search.find(@q, [klass.classify])
      end
    end
  end
  
end
