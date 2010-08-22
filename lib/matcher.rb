module Matcher
  class Match
    attr_accessor :freight
    alias f freight
    attr_accessor :loading_space
    alias l loading_space
    
    def initialize(_freight, _loading_space)
      self.freight = _freight
      self.loading_space = _loading_space
    end
    
    def comparing_attributes
      private_methods.select { |m| 
        m =~ /^compare_/ 
      }.map { |m| 
        m.gsub(/^(compare_)(.+)/, '\2') 
      }
    end
    
    def comparing_hash
      comparing_attributes.inject({}) { |hsh, attr|
        m = method("compare_#{attr}")
        hsh[attr] = m.call(f.__send__(attr), l.__send__(attr)).to_f
        hsh
      }
    end
    
    def percentage
      hsh = comparing_hash
      sum = hsh.inject(0.0) { |sum, (attr, p)| sum + p }
      sum / hsh.keys.size
    end
    alias to_f percentage
    
    def without_ids(attributes)
      attributes.delete_if { |k, v| k =~ /(\A|_)id$/ }
    end
    
    private
    
    def __compare_site_info__(a, b)
      aa, bb = without_ids(a.attributes), without_ids(b.attributes)
      Compare::Hash.new(aa, bb).to_f
    end
    
    def compare_origin_site_info(a, b)
      __compare_site_info__(a, b)
    end
    
    def compare_destination_site_info(a, b)
      __compare_site_info__(a, b)
    end
    
    def compare_attributes(a, b)
      bb = without_ids(b)
      Compare::Hash.new(bb, a).to_f
    end
  end
  
  module Compare
    class Base
      attr_accessor :a
      attr_accessor :b

      def initialize(_a, _b)
        self.a = _a
        self.b = _b
      end

      def percentage
        a == b ? 1.0 : 0.0
      end
      
      def to_f
        percentage
      end
    end
      
    class Fixnum < Base
      def percentage
        ab = [a.to_f, b.to_f]
        ab.min / ab.max
      end
    end
    
    class Hash < Base
      def percentage
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
      
      def percentage
        diff = Levenshtein.distance(a, b)
        1 - (diff / [a.length, b.length].max.to_f)
      end
    end
    
    class Time < Fixnum
      def percentage
        ab = [a.to_f, b.to_f]
        ab.min / ab.max
      end
    end
    
  end
end