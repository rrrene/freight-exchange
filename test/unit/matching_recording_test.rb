require 'test_helper'

class MatchingRecordingTest < ActiveSupport::TestCase
  should belong_to(:a)
  should belong_to(:b)

  should validate_presence_of(:result)
end
