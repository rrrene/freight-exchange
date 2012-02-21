#!/usr/bin/env ruby -wKU

require 'rubygems'
require 'active_resource'
require 'active_support/inflector'
require 'factory_girl'
require 'random_data'
require 'faker'

%w(actions active_resource_ext array_ext string_ext bot users places user review).each do |rb|
  require File.join(File.dirname(__FILE__), 'robot', rb)
end

def create_robot_army!(size = 10)
  size.times do
    Factory.create(:AdminRobot)
  end
end

Factory.define "AdminRobot", :class => "User" do |u|
  u.company_attributes {
    company = {}
    place = Robot::Places.new.origin
    company[:name] = Faker::Company.name
    company[:zip] = place[:zip]
    company[:city] = place[:city]
    company[:phone] = Random.international_phone
    company[:email] = Random.email
    company[:website] = Faker::Internet.domain_name
    company
  }  
  u.person_attributes {
    person = {}
    person[:gender] = Random.boolean ? 'female' : 'male'
    person[:first_name] = Random.method("firstname_#{person[:gender]}").call
    person[:last_name] = Random.lastname
    person
  }
  u.login { "robot_#{Faker::Internet.user_name}" }
  u.email { Random.email }
  u.password 'asdf'
  u.password_confirmation { |o| o.password }
end

module Robot
  class << self
    def create(klass, attributes = nil)
      create_by_active_record(klass, attributes)
    end
    
    def create_by_active_resource(klass, attributes)
      puts "creating by active resource: #{klass}"
      resource_class = "::Robot::#{klass}".constantize
      resource_class.create
    end
    
    def create_by_active_record(klass, attributes)
      attributes ||= Factory.attributes_for("Robot::#{klass}")
      resource_class = "::#{klass}".constantize
      resource = resource_class.new(attributes)
      resource.user_id = CurrentUser.id if resource.respond_to?(:user_id)
      resource.company_id = CurrentUser.company_id if resource.respond_to?(:company_id)
      resource.save!
      resource
    end
  end
end