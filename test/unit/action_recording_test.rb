require 'test_helper'

class ActionRecordingTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:company)
end
