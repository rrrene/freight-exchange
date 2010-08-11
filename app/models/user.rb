class User < ActiveRecord::Base
  belongs_to :company
  accepts_nested_attributes_for :company
  has_and_belongs_to_many :roles, :class_name => 'UserRole', :uniq => true
  after_destroy { |user| user.company.ensure_admin }
  brackets_find_by :login
  acts_as_authentic
  searchable

  # Returns if a user has a certain role.
  def has_role?(name)
    roles.include?(UserRole[name])
  end
  alias is? has_role?
  
  def name
    login
  end
  
end