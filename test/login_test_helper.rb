
module LoginTestHelper
  # Add more helper methods to be used by all tests here...
  
  def assert_login_required(user = standard_user, &block)
    yield(user)
    assert_response :redirect
    login!(user)
    yield(user)
    assert_response :success
  end
  
  def assert_no_login_required(user = standard_user, &block)
    yield(user)
    assert_response :success
    # TODO: would it be better to include this?
    #login!(user)
    #yield(user)
    #assert_response :redirect
  end
  
  def assert_no_login_required_for(*actions)
    actions.each do |action|
      assert_no_login_required do
        get action
      end
    end
  end
  
  def assert_login_required_for(*actions)
    actions.each do |action|
      assert_login_required do
        get action
      end
    end
  end
  
  def login!(user = nil)
    user ||= standard_user
    user = case user
      when User
        user
      when Integer
        User.find(user)
      when Symbol
        users(user)
      end
    UserSession.create(user)
    user
  end
  
  def logout!
    UserSession.find.destroy
  end
  
  def with_login(user = standard_user, &block)
    login!(user)
    yield(user)
    logout!
  end
  
  private
  
  def standard_user
    company_admin_user
  end
  
  def company_admin_user
    user_with_single_role(:company_admin)
  end
  
  def company_employee_user
    user_with_single_role(:company_employee)
  end
    
  def user_with_single_role(role = :company_admin)
    user = users(:employee)
    user.user_roles = [UserRole[role]]
    user
  end
  
end