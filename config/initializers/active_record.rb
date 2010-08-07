class ActiveRecord::Base
  def belongs_to?(user = current_user)
    self.user == user
  end
  alias mine? belongs_to?
end