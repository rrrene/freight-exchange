# search.rb
# 
# The Search module acts as a wrapper to whatever search engine is running 
# in the background.
module Search
  class << self
    #:call-seq:
    #   Search.clear_index_for(record)
    # 
    # Removes the search index for the given record.
    #
    #   user = User.create(:name # => 'Bob')  # => #<User id: 1, name: "Bob">
    #   Search.find 'bob'           # => [#<User id: 1, name: "Bob">]
    #
    #   Search.clear_index_for(user)
    #   Search.find 'bob'           # => []
    def clear_index_for(record)
      SimpleSearch.clear_item(record)
    end
    
    #:call-seq:
    #   Search.count(query) # => int
    #   Search.count(query, models) # => int
    # 
    # Returns the total number of results.
    #   Search.count "some query"
    #   Search.count "Berlin", [User, Company])
    def count(q, models = nil)
      SimpleSearch.count(q, :models => models)
    end
    
    #:call-seq:
    #   Search.find(query) # => array
    #   Search.find(query, models) # => array
    #   Search / query # => array
    # 
    # Returns the matching records from the database.
    #   Search.find "some query"
    #   Search.find "Berlin", [User, Company])
    #   Search / "some other query"
    def find(q, models = nil)
      SimpleSearch.search(q, :models => models)
    end
    alias / find
    
    #:call-seq:
    #   Search.update_index_for(model_or_record)
    #   Search << model_or_record
    # 
    # Adds a record or a model to the search index.
    #   Search << User.first  # update the index for a specific user
    #   Search << User        # update the index of all users
    def update_index_for(model_or_record)
      SimpleSearch.create_or_update(model_or_record)
    end
    alias << update_index_for
  end
end

class ActiveRecord::Base
  class << self
    # Adds a model to the search index.
    #
    #   class User < ActiveRecord::Base
    #     searchable
    #   end
    def searchable(opts = {})
      # TODO: Search.add(self, opts)
      simple_search(opts)
    end
  end
end