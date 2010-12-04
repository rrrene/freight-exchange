#!/usr/bin/env ruby -wKU

module Robot
  module Actions
    
    def approve_review
      humanize(Robot::Review.approve, :approved)
    end
    
    def create_posting
      if ::Freight.count > ::LoadingSpace.count
        create_loading_space
      else
        create_freight
      end
    end
    
    def create_freight
      humanize Robot::Freight.create
    end
    
    def create_loading_space
      humanize Robot::LoadingSpace.create
    end
    
    def create_review
      humanize Robot::Review.create
    end
    
    def create_user
      humanize Robot::User.create
    end
    
    def delete_posting
      if ::Freight.count > ::LoadingSpace.count
        delete_freight
      else
        delete_loading_space
      end
    end
    
    def delete_freight
      humanize Robot::Freight.delete, :deleted
    end
    
    def delete_loading_space
      humanize Robot::LoadingSpace.delete, :deleted
    end
    
    def delete_user
    end
    
    def edit_user
      humanize Robot::User.edit, :edited
    end
    
    def search
      klass = Robot::Freight
      places = Robot::Places.new
      query = [places.shift[:name], places.shift[:city], Random.boolean ? 'Gefahrgut' : ''].join(' ')
      results = klass.find(:all, :from => "/search", :params => {:q => query})
      unless results.empty?
        result = results.random
        sr = ::SearchRecording.where(:query => query).order("updated_at DESC").first
        klass.find(result.id, :params => {:search_recording_id => sr.id})
      end
      humanize "searched for '#{query}'"
    end
    
    private
    
    def humanize(resource_or_string, action = :created)
      if resource_or_string.is_a?(String) || resource_or_string.nil?
        resource_or_string.to_s
      else
        [ action,
          resource_or_string.class.to_s.gsub('Robot::', ''),
          "##{resource_or_string.attributes[:id]}"] * ' '
      end
    end
  end
end