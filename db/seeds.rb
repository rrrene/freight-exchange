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

if Rails.env == 'development'
  # Create some users to fill the db
  Seed::USERS.each do |opts|
    User.create(opts)
  end
  puts "#{User.count} Users"
  
  station_ids = Station.all.map(&:id)
  [LoadingSpace, Freight].each do |model|
    user = User[model.to_s.underscore << '_supplier']
    100.times do 
      opts = {
        :user_id => user.id,
        :origin_station_id => station_ids.shuffle.first,
        :destination_station_id => station_ids.shuffle.first,
        :origin_date => Time.now + rand(10) * 86400,
        :destination_date => Time.now + rand(10) * 86400,
        :goods_type => %w(normal radioactive explosive).shuffle.first,
        :wagon_type => %w(normal super ultra).shuffle.first,
        :weight => rand(10) * 1_000,
        :loading_meter => rand(100),
      }
      model.create(opts)
    end
    puts "#{model.count} #{model.to_s.pluralize}"
  end
end
puts "SimpleSearch.where(:item_type => 'Freight').count = " << SimpleSearch.where(:item_type => 'Freight').count.to_s