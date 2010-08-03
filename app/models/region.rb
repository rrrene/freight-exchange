class Region < ActiveRecord::Base
  belongs_to :country
  has_and_belongs_to_many :stations
    
  class << self
    def [](name)
      self.where(:name => name.to_s).first
    end
  end
  
  validates_uniqueness_of :name, :scope => :country_id
end
