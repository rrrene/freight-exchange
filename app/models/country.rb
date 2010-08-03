class Country < ActiveRecord::Base
  has_many :regions
  
  validates_uniqueness_of :name
  validates_uniqueness_of :iso
end
