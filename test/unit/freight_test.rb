require 'test_helper'

class FreightTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:company)
  should have_many(:matching_recordings).dependent(:destroy)
  should belong_to(:contact_person)
end
