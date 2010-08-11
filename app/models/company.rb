class Company < ActiveRecord::Base
  searchable
  has_many :users
  after_create :ensure_admin
  
  # Ensure there is atleast one :company_admin left
  # If no admin can be found, the first user of the company is 
  # assigned the admin role.
  def ensure_admin
    unless users.any? { |u| u.is?(:company_admin) }
      if u = users.first && admin_role = UserRole[:company_admin]
        u.roles << admin_role
      end
    end
  end
  
  validates_presence_of :name
end
