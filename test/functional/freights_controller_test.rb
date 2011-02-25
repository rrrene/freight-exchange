require 'test_helper'

class FreightsControllerTest < ActionController::TestCase
  test "should get new" do
    assert_login_required_for :new
  end

  test "should get edit" do
    user = User.first
    #assert_login_required(user) do
    # TODO:  get :edit, :id => user.company.freights.first
    #end
  end

end
