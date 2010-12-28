module ActiveRecord
  # This module can be included in ActiverRecord::Base objects to provide
  # the functionality of LocalizedInfo attributes to that object.
  # 
  # Example:
  # 
  #   class Person < ActiveRecord::Base
  #     include ActiveRecord::HasLocalizedInfos
  #   end
  # 
  module HasLocalizedInfos
    def self.included(base)
      base.__send__(:has_many, :localized_infos, :as => :item)
      base.__send__(:after_save, :update_localized_infos)
      base.__send__(:include, InstanceMethods)
    end
    
    module InstanceMethods
      def localized_infos!(array_of_hashes)
        array_of_hashes.each do |opts|
          if text = opts[:text].full?
            self.localized_info(opts[:name], opts[:lang]).text = text
          end
        end
      end
      
      def localized_info(name, lang = I18n.default_locale)
        localized_infos.select { |obj| 
          (obj.name == name.to_s) && (obj.lang == lang.to_s) 
        }.first.full? || localized_infos.build(:name => name.to_s, :lang => lang.to_s)
      end
      
      def update_localized_infos
        localized_infos.each(&:update_or_destroy!)
      end
    end
  end

  class Base
    def attributes_filled
      attr = attributes.keys.select { |k| 
        t = column_for_attribute(k).type
        [:string, :text].include?(t) && !(t =~ /(_at|_token)$/)
      }
      filled = attr.inject(0) { |sum, item|
        sum = sum + (self[item].full? ? 1 : 0)
      }
      filled / attr.size.to_f
    end
    
    # Returns if the record belongs to a certain user.
    def belongs_to?(user = current_user)
      self.user == user if self.respond_to?(:user)
    end
    alias mine? belongs_to?
    
    def human_attribute_value(attribute_name, i18n_opts = {})
      self.class.human_attribute_value(attribute_name, self[attribute_name], i18n_opts)
    end
    
    def self.human_attribute_value(attribute_name, value, i18n_opts = {})
      arr = [:activerecord, :human_attribute_values, 
              self.to_s.underscore, attribute_name, value]
      I18n.t(arr * '.', i18n_opts)
    end
    
    class << self
      # Adds a convenient [] find_by to the model utilizing the given attribute
      # and returning the first record matching the condition. Therefore this
      # is best used on attributes that go through validates_uniqueness_of.
      #
      #   class Country < ActiveRecord::Base
      #     brackets_find_by :iso_code
      #   end
      #   
      #   Country[:de] => #<Country id: 1, name: "Germany", iso_code: "de">
      def brackets_find_by(attribute_name)
        self.instance_eval "
          def [](val)
            where(:#{attribute_name} => val.to_s).first
          end
        "
      end
    end
  end
end
