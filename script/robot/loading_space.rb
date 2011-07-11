#!/usr/bin/env ruby -wKU

require 'factory_girl'

module Robot
  class LoadingSpace < ActiveResource::Base
  end
  
  Factory.define "Robot::LoadingSpace" do |f|
  f.origin_name { @places = Places.new ; @places.origin[:name] }
  f.origin_contractor { @places = Places.new ; @places.origin[:contractor] }
  f.origin_address { @places = Places.new ; @places.origin[:address] }
  f.origin_address2 { @places = Places.new ; @places.origin[:address2] }
  f.origin_zip { @places = Places.new ; @places.origin[:zip] }
  f.origin_city { @places = Places.new ; @places.origin[:city] }
  f.origin_country { @places = Places.new ; @places.origin[:country] }

  f.destination_name { @places = Places.new ; @places.destination[:name] }
  f.destination_contractor { @places = Places.new ; @places.destination[:contractor] }
  f.destination_address { @places = Places.new ; @places.destination[:address] }
  f.destination_address2 { @places = Places.new ; @places.destination[:address2] }
  f.destination_zip { @places = Places.new ; @places.destination[:zip] }
  f.destination_city { @places = Places.new ; @places.destination[:city] }
  f.destination_country { @places = Places.new ; @places.destination[:country] }

    f.weight { 1_000 * (rand * 20).to_i }
    f.loading_meter { 100 * (rand * 20).to_i }
    f.hazmat { rand < 0.5 }
    f.transport_type { %w(single_wagon train_set block_train).random }
  end
end