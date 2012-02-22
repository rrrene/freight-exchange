#!/usr/bin/env ruby -wKU

require File.join(File.dirname(__FILE__), 'places')
require File.join(File.dirname(__FILE__), 'array_ext')
require 'factory_girl'

module Robot
  class Freight < ActiveResource::Base
  end
  
  Factory.define "Robot::Freight" do |f|
    f.contractor { @places ||= Places.new ; @places.origin[:contractor] }
    f.product_name {
      all = ["Butadien", "Ethanol", "Natriumnitrit", "Kohle", "Nahrungsmittel", "Textilien", "Kunststoffe", "Holz", "Papier", "Metalle", "Maschinen", "Kraftwagen", "Möbel", "Druckerzeugnisse", "Kokereierzeugnisse", "Glas", "Keramik", "Chemische Erzeugnisse", "Erze"]
      all.sort_by { rand }.first
    }
    
    f.valid_until { Time.now + 150.days + (rand * 365.days).to_i }
    f.first_transport_at { Time.now + 150.days + (rand * 365.days).to_i }

    f.origin_name { @places ||= Places.new ; @places.origin[:name] }
    f.origin_date { @places ||= Places.new ; @places.origin[:date] }
    f.origin_contractor { @places ||= Places.new ; @places.origin[:contractor] }
    f.origin_address { @places ||= Places.new ; @places.origin[:address] }
    f.origin_address2 { @places ||= Places.new ; @places.origin[:address2] }
    f.origin_zip { @places ||= Places.new ; @places.origin[:zip] }
    f.origin_city { @places ||= Places.new ; @places.origin[:city] }
    f.origin_country { @places ||= Places.new ; @places.origin[:country] }

    f.destination_name { @places ||= Places.new ; @places.destination[:name] }
    f.destination_date { @places ||= Places.new ; @places.destination[:date] }
    f.destination_contractor { @places ||= Places.new ; @places.destination[:contractor] }
    f.destination_address { @places ||= Places.new ; @places.destination[:address] }
    f.destination_address2 { @places ||= Places.new ; @places.destination[:address2] }
    f.destination_zip { @places ||= Places.new ; @places.destination[:zip] }
    f.destination_city { @places ||= Places.new ; @places.destination[:city] }
    f.destination_country { @places ||= Places.new ; @places.destination[:country] }

    f.total_weight { 1_000 * (rand * 20).to_i }
    f.transport_weight { 100 * (rand * 20).to_i }
    f.hazmat { false }
    f.product_state { %w(liquid gas loose packaged container).random }
    f.frequency { %w(once weekly monthly yearly).random }
    f.desired_means_of_transport { %w(tank_wagon tank_container).random }
    
    f.own_means_of_transport_present { rand < 0.5 }
    f.own_means_of_transport { %w(closed_wagon container_wagon).random }
    
    f.wagons_provided_by { %w(client railway).random }
    f.desired_proposal_type { %w(ton_price package_price).random }
  end
end