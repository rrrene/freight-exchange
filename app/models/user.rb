class User < ActiveRecord::Base
  brackets_find_by :login
  has_and_belongs_to_many :roles, :class_name => 'UserRole', :uniq => true
  belongs_to :company

  acts_as_authentic
  searchable
  
  def has_role?(name)
    roles.include?(UserRole[name])
  end
  alias is? has_role?
  
  def name
    login
  end
end
