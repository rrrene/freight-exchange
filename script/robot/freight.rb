#!/usr/bin/env ruby -wKU

module Robot
  class Freight < ActiveResource::Base
    class << self
      def hazmat
        rand < 0.5
      end
      
      def transport_type
        %w(single_wagon train_set block_train).random
      end
      
      def wagons_provided_by
        %w(client railway).random
      end
      
      def desired_proposal_type
        %w(ton_price package_price).random
      end
      
      def create_attributes
        places = Places.new
        freight_attribs = {
          :origin_site_info_attributes => {
            :contractor => 'Frachtunternehmen',
          }.merge(places.origin),
          :destination_site_info_attributes => {
            :contractor => 'Frachtunternehmen',
          }.merge(places.destination),
          :weight => 1_000 * (rand * 20).to_i,
          :loading_meter => 10 * (rand * 20).to_i,
          :hazmat => hazmat,
          :transport_type => transport_type,
          :wagons_provided_by => 'railway',
          :desired_proposal_type => 'package_price',
        }
      end
    end
  end
end