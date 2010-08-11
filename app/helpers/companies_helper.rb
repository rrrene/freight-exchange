module CompaniesHelper
  def registering_new_account?
    current_user.blank?
  end
end
