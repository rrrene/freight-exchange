
class ActiveRecord::Base
  class << self
    def simple_search(options = {})
      options.reverse_merge!(:fields => nil, :simplify => true)
      simplify = options[:simplify]
      attribs = if options[:fields].blank?
        self.new.attributes.keys - %w(updated_at created_at)
      else
        options[:fields]
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
