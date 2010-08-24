class User < ActiveRecord::Base
  belongs_to :company
  belongs_to :person
  accepts_nested_attributes_for :company
  accepts_nested_attributes_for :person
  has_and_belongs_to_many :user_roles, :uniq => true
  after_save { |user| user.company.ensure_admin }
  after_destroy { |user| user.company.ensure_admin }
  brackets_find_by :login
  acts_as_authentic
  searchable
  
  #:call-seq:
  #   user.has_role?(role_name) # => boolean
  #
  # Returns true if a user has a certain role.
  #   user.has_role?(:administrator) # => true
  def has_role?(name)
    roles.include?(name.to_s)
  end
  alias is? has_role?
  
  def name # :nodoc:
    person.name
  end
  
  #:call-seq:
  #   user.roles # => array
  #
  # Returns an array of role names.
  #   user.roles # => ["administrator", "company_admin"]
  def roles
    @roles ||= user_roles.map(&:name)
  end
  
  # For permission handling
  def user # :nodoc:
    self
  end
  
end