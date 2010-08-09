class Company < ActiveRecord::Base
  searchable
  has_one :user
  
  validates_presence_of :name
end
