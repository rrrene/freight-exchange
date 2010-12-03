#!/usr/bin/env ruby -wKU

require 'factory_girl'

module Robot
  class User < ActiveResource::Base
    class << self
      def edit
        resource = self.find(CurrentUser.id)
        resource.login = "robot_#{Faker::Internet.user_name}"
        resource.save
        resource
      end
    end
  end
  
  Factory.define "Robot::User" do |u|
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
end