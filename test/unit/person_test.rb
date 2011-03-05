require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  should have_one(:user)
  should have_one(:company).through(:user)
  
  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)
  %w(male female).each { |v| should allow_value(v).for(:gender) }
  %w(de en).each { |v| should allow_value(v).for(:locale) }
end
