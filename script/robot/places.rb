#!/usr/bin/env ruby -wKU

module Robot
  class Places
    @@places = [
      {
        :contractor => 'Frachtunternehmen',
        :name => 'Bochum Hbf',
        :address => "Kurt-Schumacher-Platz",
        :zip => "44787",
        :city => "Bochum",
        :country => "Germany",
        :date => Time.new,
        :side_track_available => true,
      },
      {
        :contractor => 'Frachtunternehmen',
        :name => 'Dortmund Hbf',
        :address => "Bahnhofstr.",
        :zip => "44137",
        :city => "Dortmund",
        :country => "Germany",
        :date => Time.new + 87600,
        :side_track_available => true,
      },
      {
        :contractor => 'Frachtunternehmen',
        :name => 'Essen Hbf',
        :address => "Am Hauptbahnhof",
        :zip => "45128",
        :city => "Essen",
        :country => "Germany",
        :date => Time.new + 87600,
        :side_track_available => true,
      },
    ]
    
    def initialize
      @places = @@places.clone.sort_by { rand }
    end
    
    def shift
      @places.shift
    end
    alias origin shift
    alias destination shift
  end
end