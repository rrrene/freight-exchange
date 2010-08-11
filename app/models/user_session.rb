class UserSession < Authlogic::Session::Base
  
  def self.login(user)
    self.new(user).save
  end
  
end