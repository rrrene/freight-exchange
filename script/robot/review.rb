#!/usr/bin/env ruby -wKU

require 'factory_girl'

module Robot
  class Review < ActiveResource::Base
    class << self
      def approve
        if id = unapproved_review_id
          resource = self.find(id)
          resource.approved_by_id = Robot::CurrentUser.id
          resource.save
          resource
        end
      end
      
      def unapproved_review_id
        company = ::User.find(CurrentUser.id).company
        company.unapproved_reviews.first.try(:id)
      end
    end
  end
  
  Factory.define "Robot::Review" do |r|
    r.company_id { ::Company.all.random.id }
    r.text { Random.paragraphs }
  end
end