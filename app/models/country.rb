class Country < ActiveRecord::Base
  has_many :regions
  has_many :stations
  
  class << self
    def [](iso)
      self.where(:iso => iso.to_s).first
    end
  end
  
  validates_uniqueness_of :name
  validates_uniqueness_of :iso
end
