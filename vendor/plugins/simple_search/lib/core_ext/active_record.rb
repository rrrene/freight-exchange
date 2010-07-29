
class ActiveRecord::Base
  class << self
    # Adds a model to the search index.
    #
    #   class User < ActiveRecord::Base
    #     simple_search
    #   end
    # 
    # Omit the attributes option and all attributes are automatically indexed, but
    # sometimes you might not want that (especially in case of users):
    # 
    #   class User < ActiveRecord::Base
    #     simple_search :attributes => %w(email login)
    #   end
    def simple_search(options = {})
      options.reverse_merge!(:attributes => nil, :simplify => true)
      simplify = options[:simplify]
      attribs = if options[:attributes].blank?
        self.new.attributes.keys - %w(updated_at created_at)
      else
        options[:attributes]
      end
      define_method(:to_search) do
        str = attribs.map { |a| self[a] }.join(' ')
        simplify && str.respond_to?(:simplify) ? str.simplify : str
      end
      after_create { |record| SimpleSearch << record }
      after_update { |record| SimpleSearch << record }
      before_destroy { |record| SimpleSearch.clear_item(record) }
    end
  end
end
