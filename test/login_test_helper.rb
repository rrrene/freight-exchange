
module LoginTestHelper
  # Add more helper methods to be used by all tests here...
  
  def assert_login_required(user = standard_user, &block)
    yield(user)
    assert_response :redirect
    login!(user)
    yield(user)
    assert_response :success
  end
  
  def assert_login_required_for(action, parameters = {})
    assert_login_required do
      get action, parameters
    end
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
  
  def assert_permission_denied(user = nil, &block)
    login_if_user_present_yield_otherwise(user, &block)
    assert_response 401
  end
  
  def assert_permission_granted(user = nil, &block)
    login_if_user_present_yield_otherwise(user, &block)
    assert_response :success
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
    UserSession.find.full?(&:destroy)
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
    role_user(:company_admin)
  end
  
  def company_employee_user
    role_user(:company_employee)
  end
    
  def login_if_user_present_yield_otherwise(user, &block)
    if user.blank?
      yield
    else
      with_login(user, &block)
    end
  end
  
  def user_with_single_role(role = :company_admin)
    user = users(role)
    if user
      user.user_roles = [UserRole[role]]
    else
      raise "Could not find user '#{role}' in fixtures."
    end
    user
  end
  alias role_user user_with_single_role
  
end