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
  
  #:call-seq:
  #   UserRole.frontend_roles # => Array
  #
  # Returns an array with all UserRoles that can be assigned via the frontend.
  #
  #   UserRole.frontend_roles.map(&:name)
  #     # => ['company_admin', 'company_employee', 'company_intern']
  def self.frontend_roles
    where('name LIKE ?', 'company_%')
  end
  
  #:call-seq:
  #   UserRole.backend_roles # => Array
  #
  # Returns an array with all UserRoles that can be assigned only via the backend.
  #
  #   UserRole.backend_roles.map(&:name)
  #     # => ['administrator', 'marketing', 'support']
  def self.backend_roles
    where('name NOT LIKE ?', 'company_%')
  end
  
  #:call-seq:
  #   user_role.user_count # => int
  #
  # Returns the number of users who have this UserRole.
  #
  #   UserRole[:company_admin].user_count
  #     # => 521
  def user_count
    users.count
  end
  
  #:call-seq:
  #   user_role.user_percentage # => Float
  #
  # Returns the percentage of users who have this UserRole.
  #
  #   UserRole[:company_admin].user_percentage
  #     # => 0.763
  def user_percentage
    users.count / User.count.to_f
  end
  
  validates_uniqueness_of :name, :case_insensitive => false
end
