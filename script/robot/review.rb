#!/usr/bin/env ruby -wKU

require 'factory_girl'

module Robot
  class Review < ActiveResource::Base
  end
  
  Factory.define "Robot::Review" do |r|
    r.company_id { ::Company.all.random.id }
    r.text { Random.paragraphs }
  end
end