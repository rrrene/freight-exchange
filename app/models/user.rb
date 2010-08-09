class User < ActiveRecord::Base
  belongs_to :company
  acts_as_authentic
  searchable

  def name
    login
  end

  class << self
    def [](login)
      self.where(:login => login.to_s).first
    end
  end
end
