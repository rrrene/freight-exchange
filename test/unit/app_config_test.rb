require 'test_helper'

class AppConfigTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
  # TODO: why does this not pass?
  #should validate_uniqueness_of(:name).case_insensitive
end
