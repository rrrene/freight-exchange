class AppConfig < ActiveRecord::Base
  searchable
  
  class << self
    attr_accessor :defaults
    
    def by_name(name)
      where(:name => name.to_s).limit(1).first
    end
    
    def [](name)
      by_name(name).full?(&:value) || APP_CONFIG_DEFAULTS[name.to_s]
    end
    
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
