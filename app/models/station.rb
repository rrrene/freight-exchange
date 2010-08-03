class Station < ActiveRecord::Base
  has_and_belongs_to_many :regions, :uniq => true
  
  validates_presence_of :country_id
  validates_uniqueness_of :name
end
