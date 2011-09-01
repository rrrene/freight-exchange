
module ::RemoteControllerTests
  def test_should_get_new
    assert_login_required_for :new
  end
  
  def test_should_post_create
    with_login do
     post :create, model_sym => other_attributes
     assert_response :redirect
    end
  end
  
  def test_should_get_index
    assert_login_required_for :index
  end

  def test_should_delete_destroy
    setup_model
    with_login do
     delete :destroy, :id => setup_model.id
     assert_response :redirect
  #   assert !tested_model.exists?(setup_model.id)
    end
  end
  
  def test_should_get_edit
    setup_model
    assert_login_required do
     get :edit, :id => setup_model.id
    end
  end
  
  def test_should_put_update
    setup_model
    with_login do
     put :update, :id => setup_model.id, model_sym => other_attributes
     assert_response :redirect
    end
  end
  
  def test_should_get_show
    setup_model
    assert_login_required do
     get :show, :id => setup_model.id
    end
  end
  
  private
  
  def setup_model
    @set_up_model ||= create_model
  end
  
  def other_attributes
    model_factory.factory_attributes
  end
  
end
