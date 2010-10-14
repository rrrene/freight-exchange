#!/usr/bin/env ruby -wKU

require 'rubygems'
require 'active_resource'

SITE = "http://localhost:3000/"
API_KEY = "55024db979499d5568f0859d046da09f47234a74"

class Freight < ActiveResource::Base
  self.site = SITE
  self.user = API_KEY
end

f = Freight.create({
  :origin_site_info_attributes => {
    :contractor => 'Frachtunternehmen',
    :address => "Kurt-Schumacher-Platz",
    :zip => "44787",
    :city => "Bochum",
    :country => "Germany",
    :date => Time.new,
    :side_track_available => true,
  },
  :destination_site_info_attributes => {
    :contractor => 'Frachtunternehmen',
    :address => "Bahnhofstr.",
    :zip => "44137",
    :city => "Dortmund",
    :country => "Germany",
    :date => Time.new + 1.day,
    :side_track_available => true,
  },
  :weight => 1_000,
  :loading_meter => 10,
  :hazmat => false,
  :transport_type => 'single_wagon',
  :wagons_provided_by => 'railway',
  :desired_proposal_type => 'package_price',
})


puts Freight.all.size.to_s << " Freights available"
