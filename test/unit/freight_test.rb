require 'test_helper'

class FreightTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:company)
  should belong_to(:origin_site_info).dependent(:destroy)
  should belong_to(:destination_site_info).dependent(:destroy)
  should have_many(:matching_recordings).dependent(:destroy)
  should belong_to(:contact_person)
end
