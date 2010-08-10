class Region < ActiveRecord::Base
  brackets_find_by :name
  belongs_to :country
  has_and_belongs_to_many :stations
  
  validates_uniqueness_of :name, :scope => :country_id
end
