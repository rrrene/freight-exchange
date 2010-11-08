class Admin::SearchController < Admin::BaseController
  
  def index
    @sidebar_result_models = %w(users company)
    @results = {}
    if @q = params[:q].full?
      @results = search_for(@q)
      @sidebar_result_models.each do |klass|
        @results[klass] = Search.find(@q, [klass.classify])
      end
    end
  end
  
  def search_for(q)
    count = Search.count(q)
    {
      :main => Search.find(q),
      :count => count
    }
  end
  
end
