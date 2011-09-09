#!/usr/bin/env ruby -wKU

require 'rubygems'
require 'active_resource'
require 'active_support/inflector'
require 'factory_girl'
require 'random_data'
require 'faker'

class User < ActiveRecord::Base
  ROBOT_ARMY_SIZE = 30
  scope :robots, where('login LIKE "robot_%"')
end

%w(actions active_resource_ext array_ext bot users places user review).each do |rb|
  require File.join(File.dirname(__FILE__), 'robot', rb)
end

Factory.define "AdminRobot", :class => "User" do |u|
  u.company_attributes {
    company = {}
    company[:name] = Faker::Company.name
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
  u.posting_type { User.last.posting_type == 'Freight' ? 'LoadingSpace' : 'Freight' }
end

def create_robot_army!(size = 10)
  size.times { 
    bot = Factory.build(:AdminRobot)
    if bot.save
      puts "Created #{bot.login}"
    else
      puts bot.errors.full_messages
    end
  }
end