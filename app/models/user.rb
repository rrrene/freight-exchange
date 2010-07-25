class User < ActiveRecord::Base
  acts_as_authentic
  simple_search :fields => %w(email login)
end
