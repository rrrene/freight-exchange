# The SearchController provides all search functionality for the app.
class SearchController < ApplicationController
  login_required
  
  def advanced
    if request.post?
      @arel = Freight.where(:weight => 10)
    end
  end
  
  def index
    @sidebar_result_models = %w(company station)
    @results = {}
    if @q = params[:q].full?
      @results = search_for(@q)
      @sidebar_result_models.each do |klass|
        @results[klass] = Search.find(@q, [klass.classify])
      end
    end
    respond_to do |format|
      format.html
      format.xml { render :xml => @results[:main] }
      format.json { render :json => @results[:main] }
    end
  end
  
  private
  
  def search_for(q)
    count = Search.count(q, [current_user.search_type])
    @search_recording = current_user.search_recordings.create({:query => q, :results => count})
    {
      :main => Search.find(q, [current_user.search_type]),
      :count => count
    }
  end
  
end
