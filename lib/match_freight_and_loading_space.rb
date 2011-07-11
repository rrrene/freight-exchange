require 'matching'

module Matching
  class << self
    #:call-seq:
    #   Match.compare_freight_and_loading_space(freight, space) # => Float
    #   Match.fls(freight, space) # => Float
    #
    # Returns the likeness of a Freight and a LoadingSpace object.
    #   Match.fls(Freight.first, LoadingSpace.first) # => 0.977920227850516
    def compare_freight_and_loading_space(f = Freight.first, l = LoadingSpace.first)
      Compare::FreightToLoadingSpace.new(f, l).result
    end
    alias fls compare_freight_and_loading_space
  end
  
  module Compare
    # Compares a Freight with a LoadingSpace object by comparing their attributes.
    class FreightToLoadingSpace < Base
      compare :origin_name
      compare :origin_contractor
      compare :origin_address
      compare :origin_address2
      compare :origin_zip
      compare :origin_city
      compare :origin_country
      
      compare :destination_name
      compare :destination_contractor
      compare :destination_address
      compare :destination_address2
      compare :destination_zip
      compare :destination_city
      compare :destination_country
      
      compare :weight, :threshold => {:up => 0}
      compare :hazmat?, :threshold => :perfect
    end
    
    # Compares two SiteInfo objects by comparing their attributes.
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
