
# Create a basis of participating countries
[
  {:iso => 'de', :name => 'Germany'},
  {:iso => 'ch', :name => 'Switzerland'},
  {:iso => 'fr', :name => 'France'},
  {:iso => 'it', :name => 'Italy'},
  {:iso => 'nl', :name => 'Netherlands'},
].each do |opts|
  Country.create(opts)
end

puts "#{Country.count} Countries: #{Country.all.map(&:iso).inspect}"


# Create some sample regions
{
  :de => [
    {:name => 'Rhein-Neckar'},
    {:name => 'Rhein-Main'},
    {:name => 'Ruhr'},
    {:name => 'Westfalen'},
  ],
  :nl => [
    {:name => 'Utrecht'},
  ]
}.each do |iso, opts_arr|
  country = Country[iso]
  opts_arr.each do |opts|
    country.regions.create(opts)
  end
end

puts "#{Region.count} Regions"


# Create some stations
{
  :de => [
    {:name => 'Bochum Hbf', :regions => ['Ruhr', 'Westfalen']},
    {:name => 'Dortmund Hbf', :regions => ['Ruhr', 'Westfalen']},
    {:name => 'Essen Hbf', :regions => ['Ruhr', 'Westfalen']},
  ]
}.each do |iso, opts_arr|
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