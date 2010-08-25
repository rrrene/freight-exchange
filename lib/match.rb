# match.rb
#
module Match
  module Compare
    class Base
      @@compared_attributes = {}
      attr_accessor :a
      attr_accessor :b

      def initialize(_a, _b)
        self.a = _a
        self.b = _b
      end
      
      def calc_result(hsh)
        arr = hsh.values
        arr.inject(0.0) { |sum, el| sum + el } / arr.size
      end
      
      def compare_attribute(attr, opts = {})
        x, y = a.__send__(attr), b.__send__(attr)
        comparer = comparer_for(opts[:as] || x.class)
        result = comparer.new(x, y).result
        result = false unless in_threshold(x, y, result, opts[:threshold])
        result = opts[:block].call(x, y, result) if opts[:block]
        result
      end
      
      def compare_attributes_and_calc_result
        all = compared_attributes.inject({}) do |hsh, (attr, opts)|
          if result = compare_attribute(attr, opts)
            hsh[attr] = result
          else
            return 0.0
          end
          hsh
        end
        calc_result(all)
      end
      
      def compared_attributes
        @@compared_attributes[self.class.name] || nil
      end
      
      def comparer_for(klass)
        eval("Match::Compare::#{klass}")
      end
      
      # Floats are interpreted as relative, Fixnums as absolute thresholds.
      def in_threshold(x, y, result, threshold = {})
        valid = true
        
        if threshold.is_a?(::Float) || threshold.is_a?(::Fixnum)
          threshold = {:up => threshold, :down => threshold}
        elsif threshold == :perfect
          return result == 1.0
        elsif threshold.nil?
          return true
        end
        
        if (up = threshold[:up]) && (x > y)
          if up.is_a?(::Float)
            valid &&= (result > 1.0 - up)
          elsif up.is_a?(::Fixnum)
            valid &&= (x <= y + up)
          end
        end
        
        if (down = threshold[:down]) && (x < y)
          if down.is_a?(::Float)
            valid &&= (result > 1.0 - down)
          elsif up.is_a?(::Fixnum)
            valid &&= (x >= y - down)
          end
        end
        
        valid
      end
      
      def result
        if compared_attributes
          compare_attributes_and_calc_result
        else
          a == b ? 1.0 : 0.0
        end
      end
      
      def to_f
        result
      end
      
      class << self
        def compare(*args, &block)
          @@compared_attributes[name] ||= {}
          opts = args.last.is_a?(::Hash) ? args.pop : {}
          opts[:block] = block if block_given?
          attribs = args
          attribs.each do |attr|
            @@compared_attributes[name][attr] = opts
          end
        end
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
          comparer = comparer_for(value.class)
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
  end
end