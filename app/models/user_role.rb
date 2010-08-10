class UserRole < ActiveRecord::Base
  has_and_belongs_to_many :users, :uniq => true
  
  class << self
    def [](name)
      where(:name => name.to_s).first
    end
  end
  
  validates_uniqueness_of :name
end
