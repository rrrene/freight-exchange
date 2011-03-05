require 'test_helper'

class UserRoleTest < ActiveSupport::TestCase
  should have_and_belong_to_many(:users)
  
  # TODO: this should pass
  #should validate_uniqueness_of(:name).case_insensitive
end
