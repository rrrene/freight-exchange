class User < ActiveRecord::Base
  acts_as_authentic
  simple_search :attributes => %w(email login)
end
