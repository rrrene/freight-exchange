# AppConfig objects store system specific configuration values for the 
# application.
# 
# Use [] and []= to create and store any information.
#   AppConfig[:language]  # => "en"
#   AppConfig[:language] = 'de'  # => "de"
#   AppConfig[:some_option] = 'some value' # => "some value"
class AppConfig < ActiveRecord::Base
  searchable
  
  class << self
    #attr_accessor :defaults
    
    def by_name(name) # :nodoc:
      where(:name => name.to_s).limit(1).first
    end
    
    #:call-seq:
    #   AppConfig[key] # => Object
    #
    # Returns the value stored for key in the database or its default value.
    #   AppConfig[:language]  # => "en"
    def [](name)
      by_name(name).full?(&:value) || APP_CONFIG_DEFAULTS[name.to_s]
    end
    
    #:call-seq:
    #   AppConfig[key] = value
    #
    # Stores the value for key in the database.
    #   AppConfig[:language] = 'de'  # => "de"
    def []=(name, value)
      if existing = by_name(name).full?
        existing.update_attribute(:value, value)
      else
        create(:name => name.to_s, :value => value)
      end
    end
  end
  
  validates_presence_of :name, :message => "can't be blank"
  validates_uniqueness_of :name, :message => "must be unique"
end
