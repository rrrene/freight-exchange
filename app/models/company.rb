# Company objects represent the organisation of a User.
# 
# Each Company has different types of users, e.g. admins.
class Company < ActiveRecord::Base
  searchable
  has_many :users
  has_many :people, :through => :users
  belongs_to :contact_person, :class_name => 'Person'
  has_many :recordings, :order => 'created_at DESC'
  has_many :reviews, :order => 'created_at DESC'
  has_many :freights, :order => 'created_at DESC'
  has_many :loading_spaces, :order => 'created_at DESC'

  def approved_reviews
    reviews.where('approved_by_id IS NOT NULL')
  end

  include ActiveRecord::HasLocalizedInfos
  def localized_infos=(array_of_hashes)
    localized_infos!(array_of_hashes)
  end
  
  # For permission handling
  def company # :nodoc:
    self
  end
  
  # Ensures there is at least one <tt>:company_admin</tt> left in this 
  # company.
  # If no admin can be found, the first user of the company is 
  # assigned the admin role.
  def ensure_admin
    unless users.any? { |u| u.is?(:company_admin) }
      if (u = users.first) && (admin_role = UserRole[:company_admin])
        u.user_roles << admin_role
      end
    end
  end

  def unapproved_reviews
    reviews.where('approved_by_id IS NULL')
  end
  
  def website
    address = self[:website]
    if address.blank? || address =~ /^\w+\:\/\//
      address
    else
      "http://#{address}"
    end
  end
  
  validates_presence_of :name
  validates_uniqueness_of :name
end
