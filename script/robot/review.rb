#!/usr/bin/env ruby -wKU

require 'factory_girl'

module Robot
  class Review < ActiveResource::Base
    class << self
      def approve
        login {
          resource = self.find(unapproved_review_id)
          resource.approved_by_id = Robot::CurrentUser.id
          resource.save
          resource
        }
      end
      
      def unapproved_review_id
        company = ::User.find(CurrentUser.id).company
        company.unapproved_reviews.first.id
      end
    end
  end
  
  Factory.define "Robot::Review" do |r|
    r.company_id { ::Company.all.random.id }
    r.text { Random.paragraphs }
  end
end