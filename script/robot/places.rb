#!/usr/bin/env ruby -wKU

module Robot
  class Places
    @plain_names = %w(Rotterdam Utrecht Genoa)
    @@creation_date = lambda { |place| Time.new + (87600 * 365 * rand).to_i }
    @@places = [
      {
        :contractor => 'Frachtunternehmen',
        :name => 'Bochum Hbf',
        :address => "Kurt-Schumacher-Platz",
        :zip => "44787",
        :city => "Bochum",
        :country => "Germany",
        :date => @@creation_date,
        :side_track_available => true,
      },
      {
        :contractor => 'Frachtunternehmen',
        :name => 'Dortmund Hbf',
        :address => "Bahnhofstr.",
        :zip => "44137",
        :city => "Dortmund",
        :country => "Germany",
        :date => @@creation_date,
        :side_track_available => true,
      },
      {
        :contractor => 'Frachtunternehmen',
        :name => 'Essen Hbf',
        :address => "Am Hauptbahnhof",
        :zip => "45128",
        :city => "Essen",
        :country => "Germany",
        :date => @@creation_date,
        :side_track_available => true,
      }
    ] + @plain_names.map { |name|
        {
          :contractor => 'Frachtunternehmen',
          :name => name,
          :address => "Am Hauptbahnhof",
          :zip => "45128",
          :city => name,
          :country => "",
          :date => @@creation_date,
          :side_track_available => Random.boolean,
        }
      } 
    
    def initialize
      @places = @@places.clone.sort_by { rand }
    end
    
    def shift(origin = nil)
      place = @places.clone.shift
      place.each do |key, value|
        place[key] = value.call(place) if value.is_a?(Proc)
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