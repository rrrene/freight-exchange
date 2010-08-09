class User < ActiveRecord::Base
  acts_as_authentic
  simple_search
  belongs_to :company

  def name
    login
  end

  class << self
    def [](login)
      self.where(:login => login.to_s).first
    end
  end
end
