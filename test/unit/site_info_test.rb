require 'test_helper'

class SiteInfoTest < ActiveSupport::TestCase
  should validate_presence_of(:contractor)
  should validate_presence_of(:name)
  
  [true, false].each { |v| should allow_value(v).for(:side_track_available) }
end
