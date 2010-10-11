# AppConfig objects store system specific configuration values for the 
# application.
#
# == Reading
#
# Read any value from the database (or the default config yaml, if it is not yet in the db) by using the [] accessor.
#
#   AppConfig[:language]  # => "en"
#
# == Storing
#
# Store any value in the database by using the []= accessor.
#
#   AppConfig[:language] = 'de'  # => "de"
#   AppConfig[:some_option] = 'some value' # => "some value"
#
class AppConfig < ActiveRecord::Base
  searchable
  serialize :value
  
  class << self
    #attr_accessor :defaults
    
    def by_name(name) # :nodoc:
      where(:name => name.to_s).first
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
        #existing.update_attribute(:value, value)
        existing.value = value
        existing.save
      else
        create(:name => name.to_s, :value => value)
      end
    end
  end
  
  validates_presence_of :name, :message => "can't be blank"
  validates_uniqueness_of :name, :message => "must be unique"
end
