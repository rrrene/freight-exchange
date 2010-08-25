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
    SimpleSearch << station
  end
end
puts "#{Station.count} Stations"

# Create basic user roles
Seed::USER_ROLES.each do |opts|
  UserRole.create(opts)
end
puts "#{UserRole.count} UserRoles"

if Rails.env == 'development'
  # Create some users to fill the db
  Seed::USERS.each do |opts|
#    company_opts = opts.delete(:company)
#    company = Company.create(company_opts)
#    person_opts = opts.delete(:person)
#    person = Person.create(person_opts)
    user = User.new(opts)
#    user.company = company
#    user.person = person
    user.save
  end
  puts "#{User.count} Users"
  
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
  f.user = User[:freight_supplier]
  f.company = User[:freight_supplier].company
  f.save!
  
  puts "#{Freight.count} Freights"
  
  
  f = LoadingSpace.create({
    :origin_site_info_attributes => {
      :contractor => 'Frachtunternehmen',
      :name => "Bochum Hbf",
      :address => "Kurt-Schumacher-Platz",
      :zip => "44787",
      :city => "Bochum",
      :country => "Germany",
      :date => Time.new,
      :side_track_available => true,
    },
    :destination_site_info_attributes => {
      :contractor => 'Frachtunternehmen',
      :name => "Dortmund Hbf",
      :address => "Bahnhofstr.",
      :zip => "44137",
      :city => "Dortmund",
      :country => "Germany",
      :date => Time.new + 1.day,
      :side_track_available => true,
    },
    :weight => 1_200,
    :loading_meter => 13,
    :hazmat => false,
    :transport_type => 'single_wagon',
  })
  f.user = User[:loading_space_supplier]
  f.company = User[:loading_space_supplier].company
  f.save!
  
  puts "#{LoadingSpace.count} LoadingSpaces"
  
  
  #station_ids = Station.all.map(&:id)
  #[LoadingSpace, Freight].each do |model|
  #  user = User[model.to_s.underscore << '_supplier']
  #  100.times do 
  #    opts = {
  #      :user_id => user.id,
  #      :origin_station_id => station_ids.shuffle.first,
  #      :destination_station_id => station_ids.shuffle.first,
  #      :origin_date => Time.now + rand(10) * 86400,
  #      :destination_date => Time.now + rand(10) * 86400,
  #      :goods_type => %w(normal radioactive explosive).shuffle.first,
  #      :wagon_type => %w(normal super ultra).shuffle.first,
  #      :weight => rand(10) * 1_000,
  #      :loading_meter => rand(100),
  #    }
  #    model.create(opts)
  #  end
  #  puts "#{model.count} #{model.to_s.pluralize}"
  #end
end
puts "SimpleSearch.where(:item_type => 'Freight').count = " << SimpleSearch.where(:item_type => 'Freight').count.to_s