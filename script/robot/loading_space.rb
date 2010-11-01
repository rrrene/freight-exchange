#!/usr/bin/env ruby -wKU

require 'factory_girl'

module Robot
  class LoadingSpace < ActiveResource::Base
  end
  
  Factory.define "Robot::LoadingSpace" do |f|
    f.origin_site_info_attributes { Places.new.origin }
    f.destination_site_info_attributes { Places.new.destination }
    f.weight { 1_000 * (rand * 20).to_i }
    f.loading_meter { 100 * (rand * 20).to_i }
    f.hazmat { rand < 0.5 }
    f.transport_type { %w(single_wagon train_set block_train).random }
  end
end