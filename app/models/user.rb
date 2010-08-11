class User < ActiveRecord::Base
  belongs_to :company
  accepts_nested_attributes_for :company
  has_and_belongs_to_many :user_roles, :uniq => true
  after_save { |user| user.company.ensure_admin }
  after_destroy { |user| user.company.ensure_admin }
  brackets_find_by :login
  acts_as_authentic
  searchable
  
  def roles
    @roles ||= user_roles.map(&:name)
  end
  
  # Returns if a user has a certain role.
  def has_role?(name)
    roles.include?(name.to_s)
  end
  alias is? has_role?
  
  def name
    login
  end
  
end