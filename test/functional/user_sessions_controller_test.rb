require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  test "should NOT require login for #new" do
    assert_no_login_required_for :new
  end
  
  test "should login via #create" do
    post :create, :user_session => {:login => "freight_supplier", :password => 'asdf'}
    assert_response :redirect
  end
  
  test "should NOT login via #create with wrong password" do
    post :create, :user_session => {:login => "freight_supplier", :password => 'something'}
    assert_response :success
  end
end
