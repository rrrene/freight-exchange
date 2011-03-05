require 'test_helper'

class LocalizedInfoTest < ActiveSupport::TestCase
  should belong_to(:item)

  should validate_presence_of(:name)
  should validate_presence_of(:lang)
  should validate_presence_of(:text)
end
