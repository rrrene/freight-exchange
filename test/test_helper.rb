ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require "authlogic/test_case"
require "demo"

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
  
  def test_should_get_edit
    setup_model
    assert_login_required do
     get :edit, :id => setup_model.id
    end
  end
  
  def test_should_post_update
    setup_model
    with_login do
     post :update, :id => setup_model.id, model_sym => other_attributes
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

module ::PostingControllerTests
  include ::RemoteControllerTests
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all
  
  include Authlogic::TestCase
  setup :activate_authlogic

  # Add more helper methods to be used by all tests here...
  
  def assert_login_required(&block)
    yield(user)
    assert_response :redirect
    login!(user)
    yield(user)
    assert_response :success
  end
  
  def assert_no_login_required(&block)
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
  
  def assert_login_required_for(*actions)
    actions.each do |action|
      assert_login_required do
        get action
      end
    end
  end
  
  def login!(user = nil)
    user ||= :freight_supplier
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
    UserSession.find.destroy
  end
  
  def with_login(user = nil, &block)
    login!(user)
    yield
    logout!
  end
  
  private
  
  def dummy_password
    'asdf'
  end
  
  def create_model
    model_factory.create(user)
  end
  
  def model_factory
    "Demo::#{model_name}".constantize
  end
  
  def model_name
    self.class.to_s.gsub(/(Controller)*Test$/, '').singularize
  end
  
  def model_sym
    model_name.underscore.to_sym
  end
  
  def user
    User.first
  end
  
  
end
