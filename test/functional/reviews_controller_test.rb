require 'test_helper'

class ReviewsControllerTest < ActionController::TestCase
  
  test "should require login for #new" do
    assert_login_required do 
      get :new, :company_id => 2
    end
  end
  
  test "should require :company_id for #new" do
    assert_raise(RuntimeError) do 
      with_login do
        get :new, :company_id => nil
      end
    end
  end
  
end
