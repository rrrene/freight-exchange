#!/usr/bin/env ruby -wKU

require 'random_data'
require File.join(File.dirname(__FILE__), 'places_data')

module Robot
  class Places
    
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