ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require "authlogic/test_case"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all
  
  include Authlogic::TestCase
  setup :activate_authlogic

  # Add more helper methods to be used by all tests here...
  
  def assert_login_required(user = User.first, &block)
    yield(user)
    assert_response :redirect
    login!(user)
    yield(user)
    assert_response :success
  end
  
  def assert_no_login_required(user = User.first, &block)
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
  
end
