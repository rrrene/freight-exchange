# UserSession objects are used to handle session management using AuthLogic.
class UserSession < Authlogic::Session::Base
  #:call-seq:
  #   UserSession.login(user) # => boolean
  #
  # Authenticates a user and logs him in.
  #   UserSession.login(User.first) # => true
  def self.login(user)
    self.new(user).save
  end
  
  # Needed for `record_key_for_dom_id` (actionpack)
  def to_key # :nodoc:
    id
  end
end