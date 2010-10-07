require 'matching'

module Matching
  class << self
    #:call-seq:
    #   Match.compare_freight_and_loading_space(freight, loading_space) # => Float
    #   Match.fls freight, loading_space # => Float
    #
    # Returns the likeness of a Freight and a LoadingSpace object.
    #   Match.fls Freight.first, LoadingSpace.first # => 0.977920227850516
    def compare_freight_and_loading_space(f = Freight.first, l = LoadingSpace.first)
      Compare::FreightToLoadingSpace.new(f, l).result
    end
    alias fls compare_freight_and_loading_space
  end
  
  module Compare
    # FreightToLoadingSpace objects compare Freight with LoadingSpace objects
    # and return a result how good they match.
    class FreightToLoadingSpace < Base
      compare :origin_site_info, :destination_site_info
      compare :weight, :threshold => {:up => 0}
      compare :hazmat?, :threshold => :perfect
    end
    
    class SiteInfo < Base
      compare :date, :as => :Time, :threshold => 1.hour
      compare :name, :address, :address2, :zip, :city, :country
    end
    
    #class Test < Base
    #  compare :weight, :in => (50..100)
    #  compare :login, :match => /.{4,8}/
    #end
  end
end