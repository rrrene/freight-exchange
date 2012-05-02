#!/usr/bin/env ruby -wKU

require 'factory_girl'

module Robot
  class LoadingSpace < ActiveResource::Base
  end
  
  Factory.define "Robot::LoadingSpace" do |f|
    f.contractor { @places ||= Places.new ; @places.origin[:name] }

    f.valid_from { Time.now }
    f.valid_until { Time.now + 150.days + (rand * 365.days).to_i }
    f.first_transport_at { Time.now + 150.days + (rand * 365.days).to_i }

    f.origin_name { @places ||= Places.new ; @places.origin[:name] }
    f.origin_contractor { @places ||= Places.new ; @places.origin[:contractor] }
    f.origin_address { @places ||= Places.new ; @places.origin[:address] }
    f.origin_address2 { @places ||= Places.new ; @places.origin[:address2] }
    f.origin_zip { @places ||= Places.new ; @places.origin[:zip] }
    f.origin_city { @places ||= Places.new ; @places.origin[:city] }
    f.origin_country { @places ||= Places.new ; @places.origin[:country] }

    f.destination_name { @places ||= Places.new ; @places.destination[:name] }
    f.destination_contractor { @places ||= Places.new ; @places.destination[:contractor] }
    f.destination_address { @places ||= Places.new ; @places.destination[:address] }
    f.destination_address2 { @places ||= Places.new ; @places.destination[:address2] }
    f.destination_zip { @places ||= Places.new ; @places.destination[:zip] }
    f.destination_city { @places ||= Places.new ; @places.destination[:city] }
    f.destination_country { @places ||= Places.new ; @places.destination[:country] }
    
    f.frequency { %w(once weekly monthly yearly).random }
    
    f.free_capacities { %w(train wagon slots).random }
    
    f.own_means_of_transport_present { rand < 0.5 }
    f.own_means_of_transport { %w(closed_wagon container_wagon).random }
  end
end