module Match
  class << self
    #:call-seq:
    #   Match.compare_freight_loading_space(freight, loading_space) # => Float
    #   Match.fls freight, loading_space # => Float
    #
    # Returns the likeness of a Freight and a LoadingSpace object.
    #   Match.fls Freight.first, LoadingSpace.first # => 0.977920227850516
    def compare_freight_loading_space(f, l)
      Compare::FreightToLoadingSpace.new(f, l).result
    end
    alias fls compare_freight_loading_space
  end
  
  module Compare
    class Base
      attr_accessor :a
      attr_accessor :b

      def initialize(_a, _b)
        self.a = _a
        self.b = _b
      end

      def result
        a == b ? 1.0 : 0.0
      end
      
      def to_f
        result
      end
    end
    
    class Fixnum < Base
      def result
        ab = [a.to_f, b.to_f]
        ab.min / ab.max
      end
    end
    
    class Hash < Base
      def result
        sum = a.inject(0.0) { |sum, (key, value)|
          comparer = eval("Matcher::Compare::#{value.class}")
          # puts key + ': ' + a[key].inspect + ' == ' + b[key].inspect
          sum + comparer.new(a[key], b[key]).to_f
        }
        sum / a.size
      end
    end
    
    class NilClass < Base
    end
    
    class TrueClass < Base
    end
    
    class FalseClass < Base
    end
    
    class String < Base
      def levenshtein(a, b)
        case
          when a.empty?: b.length
          when b.empty?: a.length
          else [(a[0] == b[0] ? 0 : 1) + levenshtein(a[1..-1], b[1..-1]),
                1 + levenshtein(a[1..-1], b),
                1 + levenshtein(a, b[1..-1])].min
        end
      end
      
      def result
        diff = Levenshtein.distance(a, b)
        1 - (diff / [a.length, b.length].max.to_f)
      end
    end
    
    class Time < Fixnum
      def result
        ab = [a.to_f, b.to_f]
        ab.min / ab.max
      end
    end
    
    class FreightToLoadingSpace < Base
      def attributes_to_compare
        private_methods.select { |m| 
          m =~ /^compare_/ 
        }.map { |m| 
          m.gsub(/^(compare_)(.+)/, '\2') 
        }
      end
      
      def individual_results
        attributes_to_compare.inject({}) { |hsh, attr|
          m = method("compare_#{attr}")
          hsh[attr] = m.call(a.__send__(attr), b.__send__(attr)).to_f
          hsh
        }
      end
      
      # Calculates the results for the individual attributes and returns
      # the weighted average of all results.
      def result
        hsh = individual_results
        sum = hsh.inject(0.0) { |sum, (attr, p)| sum + p }
        sum / hsh.keys.size
      end
      
      # Removes all primary and foreign key associations from a hash and 
      # returns a copy of it.
      #   hsh = {:id => 1, :login => 'test', :person_id => 5, :company_id => 3}
      #   withouts_ids(hsh) # => {:login => 'test'}
      def without_ids(attributes)
        attributes.delete_if { |k, v| k.to_s =~ /(\A|_)id$/ }
      end
      
      private
      
      def __compare_site_info__(a, b)
        aa, bb = without_ids(a.attributes), without_ids(b.attributes)
        Compare::Hash.new(aa, bb).result
      end
      
      def compare_origin_site_info(a, b)
        __compare_site_info__(a, b)
      end
      
      def compare_destination_site_info(a, b)
        __compare_site_info__(a, b)
      end
      
      def compare_attributes(a, b)
        bb = without_ids(b)
        Compare::Hash.new(bb, a).result
      end
    end
  end
end