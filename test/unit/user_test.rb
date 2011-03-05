require 'test_helper'

class UserTest < ActiveSupport::TestCase
  #should have_many(:freights)
  # TODO: test if a user is destroed, his freights are still there and accesible through the controller
  should belong_to(:company)
  should belong_to(:person).dependent(:destroy)
  should have_and_belong_to_many(:user_roles)
  should have_many(:action_recordings)
  should have_many(:search_recordings)
end
