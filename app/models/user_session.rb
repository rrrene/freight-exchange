class UserSession < Authlogic::Session::Base
  #:call-seq:
  #   UserSession.login(user) # => boolean
  #
  # Authenticates a user and logs him in.
  #   UserSession.login(User.first) # => true
  def self.login(user)
    self.new(user).save
  end
end