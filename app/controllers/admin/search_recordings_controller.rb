class Admin::SearchRecordingsController < Admin::BaseController
  
  def index
    super {
      records = resource_class.where("created_at > ?", Time.new - 7.days).order("created_at DESC")
      @search_recordings = records[0..100]
      @top_searched = top_searched(records)
      @top_clicked = top_clicked(records)
      @top_results = top_results(records)
    }
  end
  
  def keyword
    @query = params[:id].to_s
    @keywords = @query.split(' ')
  end
  
  private
  
  def desc(arr, value = :count)
    arr.sort_by { |item| item[value] }.reverse
  end
  
  def queries(scope, split = true)
    scope.map { |search| 
      ret = search.query.to_s
      ret = ret.split(" ") if split
      ret
    }.flatten.compact.uniq
  end
  
  def sort_and_filter(arr, value = :count)
    desc(arr, value)[0..10]
  end
  
  def top_searched(scope)
    sort_and_filter queries(scope).map { |query|
      {
        :query => query,
        :count => scope.select { |search| search.query =~ /#{query}/ }.size
      }
    }
  end
  
  def top_clicked(scope)
    sort_and_filter queries(scope, false).map { |query|
      {
        :query => query,
        :clicks => scope.select { |s| s.query.to_s.strip == query.to_s.strip }.inject(0) { |sum, s| sum += s.children.count },
      }
    }, :clicks
  end
  
  def top_results(scope)
    sort_and_filter queries(scope, false).map { |query|
      {
        :query => query,
        :results => scope.select { |s| s.query.to_s.strip == query.to_s.strip }.inject(0) { |sum, s| sum += s.results.to_i },
      }
    }, :results
  end
  
end
