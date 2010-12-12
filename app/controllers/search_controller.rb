# The SearchController provides all search functionality for the app.
class SearchController < ApplicationController
  login_required
  helper_method :searched?
  
  def advanced
    modifiers = [:contains, :is, :from, :to]
    nested_keys = %w(localized_infos origin_site_info destination_site_info)
    if type = params[:search_type]
      @posting_arel = type == 'Freight' ? Freight : LoadingSpace
      @posting_arel = Freight.order('updated_at DESC') #.includes(:origin_site_info).includes(:destination_site_info)
      modifiers.each do |modifier|
        params[modifier].each do |key, value|
          if value.full? && !nested_keys.include?(key)
            @posting_arel = @posting_arel.where(["#{key} #{advanced_sql_operator(modifier)} ?", advanced_sql_value(modifier, value)])
          end
        end
      end
      
      @origin_site_info_arel = SiteInfo.order('updated_at DESC')
      @destination_site_info_arel = SiteInfo.order('updated_at DESC')
      
      @localized_info_arel = LocalizedInfo.where(:item_type => Freight)
      modifiers.each do |modifier|
        params[modifier].each do |identifier, hash|
          if identifier == 'localized_infos'
            hash.each do |key, value|
              if value.full?
                @localized_info_arel = @localized_info_arel.where(["name = ? AND value #{advanced_sql_operator(modifier)} ?", key, advanced_sql_value(modifier, value)])
              end
            end
          elsif identifier == 'origin_site_info'
            hash.each do |key, value|
              if value.full?
                @origin_site_info_arel = @origin_site_info_arel.where(["#{key} #{advanced_sql_operator(modifier)} ?", advanced_sql_value(modifier, value)])
              end
            end
          elsif identifier == 'destination_site_info'
            hash.each do |key, value|
              if value.full?
                @destination_site_info_arel = @destination_site_info_arel.where(["#{key} #{advanced_sql_operator(modifier)} ?", advanced_sql_value(modifier, value)])
              end
            end
          end
        end
      end
      
      @postings = @posting_arel.all.select { |posting|
        @origin_site_info_arel.all.map(&:id).include?(posting.origin_site_info_id)
      }
      
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
  
  def advanced_sql_operator(modifier)
    {
      :from => '>=',
      :to => '<=',
      :is => '=',
      :contains => 'LIKE',
    }[modifier]
  end
  
  def advanced_sql_value(modifier, value)
    if modifier == :contains
      "%#{value.gsub(' ', '%')}%"
    else
      if value.is_a?(Hash) && value.keys.sort == %w(day month year)
        Date.civil(value[:year].to_i, value[:month].to_i, value[:day].to_i)
      else
        value
      end
    end
  end
  
  def search_for(q)
    count = Search.count(q, [current_user.search_type])
    @search_recording = current_user.search_recordings.create({:query => q, :results => count})
    {
      :main => Search.find(q, [current_user.search_type]),
      :count => count
    }
  end
  
  def searched?
    params[:q] || params[:search_type]
  end
  
end
