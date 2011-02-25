require 'test_helper'

class CompaniesControllerTest < ActionController::TestCase
  test "should require login for #dashboard" do
    assert_login_required_for :dashboard
  end
  
  test "should get #new without login" do
    assert_no_login_required_for :new
  end
  
  test "should create new user and company via #new" do
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
end
