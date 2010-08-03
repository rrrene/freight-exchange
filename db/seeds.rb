require File.join(File.dirname(__FILE__), 'seed_data') 

# Create a basis of participating countries
Seed::COUNTRIES.each do |opts|
  Country.create(opts)
end

puts "#{Country.count} Countries"

#
#
# Create some sample regions
Seed::REGIONS.each do |iso, opts_arr|
  country = Country[iso]
  opts_arr.each do |opts|
    country.regions.create(opts)
  end
end

puts "#{Region.count} Regions"

#
#
# Create some stations
Seed::STATIONS.each do |iso, opts_arr|
  country = Country[iso]
  opts_arr.each do |opts|
    regions = opts.delete(:regions)
    station = country.stations.create(opts)
    regions.each do |name|
      station.regions << Region[name]
    end
  end
end

puts "#{Station.count} Stations"