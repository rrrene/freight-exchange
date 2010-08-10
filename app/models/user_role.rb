class UserRole < ActiveRecord::Base
  brackets_find_by :name
  has_and_belongs_to_many :users, :uniq => true
  
  validates_uniqueness_of :name
end
