require 'test_helper'

class ContactControllerTest < ActionController::TestCase
  test "should get index" do
    assert_login_required_for :index
  end

  test "should post contact" do
    with_login do
      post :index, :text => 'some contact request'
      assert_response :redirect
    end
  end
end
