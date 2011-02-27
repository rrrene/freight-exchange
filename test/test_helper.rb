ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require "authlogic/test_case"
require "login_test_helper"
require "tested_model_helper"

require "remote_controller_tests"
require "posting_controller_tests"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  include Authlogic::TestCase
  setup :activate_authlogic
  
  include TestedModelHelper
  include LoginTestHelper
end
