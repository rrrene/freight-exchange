# SimpleSearch
# 
class SimpleSearch < ActiveRecord::Base
  belongs_to :item, :polymorphic => true
  
  class << self
    #:call-seq:
    #   SimpleSearch.create_or_update?(model_or_record)
    #   SimpleSearch << model_or_record
    # 
    # Adds a record or a model to the search index.
    #   SimpleSearch << User.first  # update the index for a specific user
    #   SimpleSearch << User        # update the index of all users
    def create_or_update(model_or_record)
      if model_or_record.is_a_or_an_array_of?(ActiveRecord::Base)
        records = [model_or_record].flatten
        records.each do |record|
          create_or_update_item(record)
        end
      else
        models = [model_or_record].flatten
        models.each do |model|
          model.all.each do |record|
            create_or_update_item(record)
          end
        end
      end
    end
    alias << create_or_update
    
    def create_or_update_item(item = nil) # :nodoc:
      return if item.blank?
      if record = self.where(['item_type = ? AND item_id = ?', item.class.to_s, item.id]).first
        record.update_attribute(:text, text_for(item))
      else
        record = self.create(:item_type => item.class.to_s, :item_id => item.id, :text => text_for(item))
      end
    end
    
    #:call-seq:
    #   SimpleSearch.clear_item(record)
    # 
    # Removes the search index for the given record.
    #
    #   user = User.create(:name => 'Bob')  #=> #<User id: 1, name: "Bob">
    #   SimpleSearch.search 'bob'           #=> [#<User id: 1, name: "Bob">]
    #
    #   SimpleSearch.clear_item(user)
    #   SimpleSearch.search 'bob'           #=> []
    def clear_item(item = nil)
      destroy_all(['item_type = ? AND item_id = ?', item.class.to_s, item.id])
    end
    
    def text_for(item) # :nodoc:
      item.respond_to?(:to_search) ? item.to_search : item.to_search_simple
    end
    
    #:call-seq:
    #   SimpleSearch.search(query) => array
    #   SimpleSearch / query => array
    # 
    # Returns the matching records from the database.
    #  SimpleSearch.search "some query"
    #  SimpleSearch / "some other query"
    def search(query, opts = {})
      opts.reverse_merge!(:model => nil, :simplify => true)
      words = query.to_s.split(' ')
      words = words.map(&:simplify) if opts[:simplify]
      origin = opts[:model] ? where(:item_type => opts[:model].to_s) : self
      words.inject(origin) { |chain, word| 
        chain.where(['text LIKE ?', '%' << word << '%'])  
      }.all.map(&:item).compact
    end
    alias / search
  end
end
