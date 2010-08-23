# UserRoles grant Users access to certain parts of the application.
#
# To access the backend e.g. a user have administrator priviligues:
#
#   user.user_roles << UserRole[:administrator]
# 
# This is also used in the frontend to restrict the priviligues of users in 
# companies.
# 
#   user.user_roles << UserRole[:company_admin]
#
class UserRole < ActiveRecord::Base
  brackets_find_by :name
  has_and_belongs_to_many :users, :uniq => true
  
  validates_uniqueness_of :name
end
