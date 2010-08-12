class Company < ActiveRecord::Base
  searchable
  has_many :users
  has_many :recordings, :order => 'created_at DESC'
  
  # For permission handling
  def company # :nodoc:
    self
  end
  
  # Ensure there is atleast one :company_admin left
  # If no admin can be found, the first user of the company is 
  # assigned the admin role.
  def ensure_admin
    unless users.any? { |u| u.is?(:company_admin) }
      if (u = users.first) && (admin_role = UserRole[:company_admin])
        u.user_roles << admin_role
      end
    end
  end
  
  def attributes_filled
    attr = attributes.keys.select { |k| 
      t = column_for_attribute(k).type
      [:string, :text].include?(t) && !(t =~ /(_at|_token)$/)
    }
    filled = attr.inject(0) { |sum, item|
      sum = sum + (self[item].full? ? 1 : 0)
    }
    filled / attr.size.to_f
  end
  
  validates_presence_of :name
  validates_uniqueness_of :name
end
