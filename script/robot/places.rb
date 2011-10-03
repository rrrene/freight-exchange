#!/usr/bin/env ruby -wKU

require 'random_data'

module Robot
  class Places
    @plain_names = %w(Mühlheim Hagen Gelsenkirchen Recklinghausen Solingen Ahlen Duisburg Oberhausen Amsterdam Rotterdam Utrecht Genoa)
    @@date_blueprint = lambda { |place, origin| 
        (origin.nil? ? Time.new : origin[:date]) + (87600 * 365 * rand).to_i 
      }
    @@places = [
      {
        :contractor => 'Frachtunternehmen',
        :name => 'Bochum Hbf',
        :address => "Kurt-Schumacher-Platz",
        :zip => "44787",
        :city => "Bochum",
        :country => "Germany",
        :date => @@date_blueprint,
        :side_track_available => true,
      },
      {
        :contractor => 'Frachtunternehmen',
        :name => 'Dortmund Hbf',
        :address => "Bahnhofstr.",
        :zip => "44137",
        :city => "Dortmund",
        :country => "Germany",
        :date => @@date_blueprint,
        :side_track_available => true,
      },
      {
        :contractor => 'Frachtunternehmen',
        :name => 'Essen Hbf',
        :address => "Am Hauptbahnhof",
        :zip => "45128",
        :city => "Essen",
        :country => "Germany",
        :date => @@date_blueprint,
        :side_track_available => true,
      }
    ] + @plain_names.map { |name|
        {
          :contractor => 'Frachtunternehmen',
          :name => name,
          :address => "Am Hauptbahnhof",
          :zip => 10_000 + (rand * 60_000).to_i,
          :city => name,
          :country => "Germany",
          :date => @@date_blueprint,
          :side_track_available => Random.boolean,
        }
      }
    
    def initialize
      @places = @@places.clone.sort_by { rand }
    end
    
    def shift(origin = nil)
      place = {}
      blueprint = @places.shift
      blueprint.each do |key, value|
        place[key] = value.is_a?(Proc) ? value.call(place, origin) : value
      end
      place
    end
    
    def origin
      @origin ||= shift
    end
    
    def destination
      @destination ||= shift(origin)
    end
    
  end
end