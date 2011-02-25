require 'test_helper'

class ContactControllerTest < ActionController::TestCase
  test "should get index" do
    assert_login_required_for :index
  end

end
