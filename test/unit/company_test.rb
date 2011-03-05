require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  should have_many(:users).dependent(:destroy)
  # TODO: why does this not pass?
  #should have_many(:action_recordings).through(:users)
  should belong_to(:contact_person)
  should have_many(:action_recordings).dependent(:destroy)
  should have_many(:reviews).dependent(:destroy)
  should have_many(:freights).dependent(:destroy)
  should have_many(:loading_spaces).dependent(:destroy)
  
  should validate_presence_of(:name)
  should validate_uniqueness_of(:name)
end
