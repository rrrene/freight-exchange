class Company < ActiveRecord::Base
  searchable
  has_many :users
  
  validates_presence_of :name
end
