require 'test_helper'

class CompaniesControllerTest < ActionController::TestCase
  test "should require login for #dashboard" do
    assert_login_required_for :dashboard
  end
  
  test "should get #new without login" do
    assert_no_login_required_for :new
  end
  
  test "should create new user and company via #create" do
    params = {
      :company => {
        :name => 'Test Company'
      },
      :user => {
        :login => 'test_user',
        :email => 'test_user@example.org',
        :password => 'asdf',
        :password_confirmation => 'asdf',
      },
      :person => {
        :first_name => 'Test',
        :last_name => 'User',
      }
    }
    post :create, params
    assert_response :redirect
  end
  
  test "should get #edit with role :company_admin" do
    assert_permission_granted(company_admin_user) do |user|
      get :edit, :id => user.company
    end
  end
  
  test "should NOT get #edit with role :company_admin" do
    assert_permission_denied(company_employee_user) do |user|
      get :edit, :id => user.company
    end
  end
  
  # ===== DOES NOT WORK PROPERLY (YET) =====
  
  test "should require role :company_admin for #edit" do
    assert_role_required(:company_admin) do |user|
      get :edit, :id => user.company.id
    end
  end
  
  def assert_role_required(role_to_pass = :company_admin, role_to_fail = :company_employee, &block)
    # TODO: this doesnot work in the same test.
    #with_login(user_with_single_role(role_to_pass)) do |user|
    #  puts "\npass: #{user.user_roles.map(&:name)}"
    #  puts request.session.inspect
    #  yield(user)
    #  assert_response :success
    #end
    with_login(user_with_single_role(role_to_fail)) do |user|
      assert_permission_denied(user, &block)
    end
  end
  
end
