# Companies are organising Users.
class Company < ActiveRecord::Base
  searchable
  has_many :users
  has_many :recordings, :order => 'created_at DESC'
  
  # For permission handling
  def company # :nodoc:
    self
  end
  
  # Ensure there is atleast one :company_admin left.
  # If no admin can be found, the first user of the company is 
  # assigned the admin role.
  def ensure_admin
    unless users.any? { |u| u.is?(:company_admin) }
      if (u = users.first) && (admin_role = UserRole[:company_admin])
        u.user_roles << admin_role
      end
    end
  end
  
  validates_presence_of :name
  validates_uniqueness_of :name
end
