# matching.rb
#
module Matching
  module Compare
    # Compare objects compare two objects A and B based on their type/class.
    # 
    # == Creation
    # 
    # Compare objects accept two constructor parameters for the A and the B object.
    #
    #   compare = Compare::String.new('one string', 'another string')
    #   compare.result # => 0.6428...
    # 
    # == Conditions
    #
    # By default, a compare object compares copies of the entire objects it is passed.
    # It is also possible to only compare certain attributes of an object.
    #
    #   class UserComparer < Matching::Compare::Base
    #     compare :gender, :weight
    #   end
    #
    # Thresholds can be used to ensure that only objects who meet certain criteria are considered alike.
    # 
    #   class UserComparer < Matching::Compare::Base
    #     compare :weight, :threshold => 10   # User A can be 10 kilos heavier or lighter than user B
    #     compare :weight, :threshold => 0.05 # User A can be 5% heavier or lighter than user B
    #     compare :weight, :threshold => {:up => 0, :down => 0.1} # User A can be 10% lighter than user B, but not any heavier.
    #     compare :weight, :threshold => :perfect # User A and B have to have the same weight
    #   end
    #
    # All object-pairs not meeting the threshold criteria are automatically assigned a result of 0.0 (not alike at all).
    #
    # == Overwriting defaults
    # 
    # Blocks can be used to override the default comparisions.
    #
    # Example:
    # 
    #   class UserCompanyComparer < Matching::Compare::Base
    #     # Do not compare the email with the default String processor
    #     # but compare the email hosts and eliminate the pair if they
    #     # are not matching.
    #     compare :email do |a, b|
    #       email_domain = /[^@]+$/
    #       a[email_domain] == b[email_domain]
    #     end
    #   end
    # 
    class Base
      @@compared_attributes = {}
      attr_accessor :a
      attr_accessor :b
      
      #:call-seq:
      #  new(a, b)
      #
      # Create a new Compare object to compare the given objects.
      def initialize(_a, _b)
        self.a = _a
        self.b = _b
      end
      
      # Compares two objects and returns a result between 
      # 0.0 (not alike) and 1.0 (perfect match).
      #
      # Examples:
      #   
      #   Comparer::Base.new(true, false) # => 0.0
      #   Comparer::Base.new(true, true) # => 1.0
      #   
      def result
        if compared_attributes
          compare_attributes_and_calc_result
        else
          # compare a and b directly.
          a == b ? 1.0 : 0.0
        end
      end
      
      def to_f # :nodoc:
        result
      end
      
      class << self
        #:call-seq:
        #  compare(*attributes, options = {}, &block)
        #
        # Specifies one or more attribute(s) that will be compared using the defined options and the block, if given.
        #
        # ==== Options
        # 
        # * <tt>:as</tt> - A Symbol identifying the Comparer class to be used (e.g. <tt>:String</tt>, <tt>:Time</tt> etc.)
        # 
        #     class UserComparer < Matching::Compare::Base
        #       compare :created_at, :as => :Time
        #     end
        #
        # * <tt>:threshold</tt> - If the attribute of the B object differs more than the given threshold the comparison fails, resulting in a 0.0 match. <tt>:up</tt> and <tt>:down</tt> options are available as well. Floats are interpreted as relative, Fixnums as absolute thresholds.
        # 
        #     class UserComparer < Matching::Compare::Base
        #       compare :weight, :threshold => 10   
        #       # =>  User A can be 10 kilos heavier or lighter than user B
        #
        #       compare :weight, :threshold => 0.05 
        #       # =>  User A can be 5% heavier or lighter than user B
        #
        #       compare :weight, :threshold => {:up => 0, :down => 0.1} 
        #       # =>  User A can be 10% lighter than user B, but not any heavier.
        #
        #       compare :weight, :threshold => :perfect 
        #       # =>  User A and B have to have the same weight
        #     end
        #
        # ==== Block evaluation
        # 
        # If a block is given, the compared attributes are passed and the result of the block is the final result for the comparison (with <tt>true</tt> being interpreted as 1.0).
        #
        #   class UserComparer < Matching::Compare::Base
        #     compare :email do |a, b|
        #       email_domain = /[^@]+$/
        #       a[email_domain] == b[email_domain]
        #     end
        #   end
        def compare(*attributes, &block)
          @@compared_attributes[name] ||= {}
          opts = attributes.last.is_a?(::Hash) ? attributes.pop : {}
          opts[:block] = block if block_given?
          attributes.each do |attr|
            @@compared_attributes[name][attr] = opts
          end
        end
      end
      
      protected
      
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
        result == true ? 1.0 : result
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
        eval("Matching::Compare::#{klass}")
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
      
    end
    
    # Compares two fixnum objects.
    class Fixnum < Base
      def result
        ab = [a.to_f, b.to_f]
        ab.min / ab.max
      end
    end
    
    # Compares to two hashes by comparing all values of hash A with their 
    # counterparts in hash B.
    class Hash < Base
      def result
        sum = a.inject(0.0) { |sum, (key, value)|
          comparer = comparer_for(value.class)
          sum + comparer.new(a[key], b[key]).to_f
        }
        sum / a.size
      end
    end
    
    class NilClass < Base # :nodoc:
    end
    
    class TrueClass < Base # :nodoc:
    end
    
    class FalseClass < Base # :nodoc:
    end
    
    # Compares two strings using Levenshtein distance.
    class String < Base
      def result
        diff = Levenshtein.distance(a, b)
        1 - (diff / [a.length, b.length].max.to_f)
      end
    end
    
    # Compares two time objects.
    class Time < Fixnum
      def result
        ab = [a.to_f, b.to_f]
        ab.min / ab.max
      end
    end
  end
end