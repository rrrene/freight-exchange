require 'test_helper'

class FreightsControllerTest < ActionController::TestCase
  setup :create_freight
  
  test "should get new" do
    assert_login_required_for :new
  end

  test "should get edit" do
    assert_login_required(user) do
     get :edit, :id => user.company.freights.first
    end
  end
  
  private
  
  def create_freight
    Demo::Freight.create(user)
  end
  
  def user
    User.first
  end
  
end
