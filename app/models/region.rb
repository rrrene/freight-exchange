class Region < ActiveRecord::Base
  belongs_to :country
  
  validates_uniqueness_of :name, :scope => :country_id
end
