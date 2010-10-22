class Country < ActiveRecord::Base
  brackets_find_by :iso
  has_many :regions
  has_many :stations
  
  def to_s
    name
  end
  
  validates_uniqueness_of :name
  validates_uniqueness_of :iso
end
