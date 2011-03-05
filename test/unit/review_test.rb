require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  should belong_to(:author_user)
  should belong_to(:author_company)
  should belong_to(:company)
  should validate_presence_of(:text)
end
