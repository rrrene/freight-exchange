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
  
  def assert_login_required(&block)
    yield
    assert_response :redirect
    login!
    yield
    assert_response :success
  end
  
  def login!(user = :freight_supplier)
    user = case user
      when Integer
        User.find(user)
      when Symbol
        users(user)
      end
    UserSession.create(user)
    user
  end
  
  private
  
  def dummy_password
    'asdf'
  end
  
end
