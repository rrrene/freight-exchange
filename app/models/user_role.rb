# UserRoles grant a logged in User access to certain parts of the application.
#
# == Creation
#
# UserRoles are created and identified via their <tt>:name</tt> attribute.
#
#   UserRole.create(:name => 'employee_of_the_month')
#
# == Find by name
#
# UserRoles can be found via their <tt>:name</tt> attribute using the 
# <tt>[]</tt> accessor.
#
#   UserRole[:employee_of_the_month]
# 
# == Assigning
#
# Finally, UserRoles can be eassigned to a User with the <tt><<</tt> operator.
#
#   user.user_roles << UserRole[:employee_of_the_month]
# 
# To access the backend e.g. a user must have administrator priviligues:
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
  searchable
  
  def self.frontend_roles
    where('name LIKE ?', 'company_%')
  end
  
  validates_uniqueness_of :name
end
