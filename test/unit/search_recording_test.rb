require 'test_helper'

class SearchRecordingTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:parent)
  should belong_to(:result)
  should have_many(:children)
  
  should validate_presence_of(:user_id)
end
