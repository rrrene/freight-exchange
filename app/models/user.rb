class User < ActiveRecord::Base
  acts_as_authentic
  simple_search

  class << self
    def [](login)
      self.where(:login => login.to_s).first
    end
  end
end
