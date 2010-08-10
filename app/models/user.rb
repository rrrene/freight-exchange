class User < ActiveRecord::Base
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

  class << self
    def [](login)
      self.where(:login => login.to_s).first
    end
  end
end
