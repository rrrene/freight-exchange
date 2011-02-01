require File.join(File.dirname(__FILE__), 'seed_data') 

# Create basic user roles
Seed::USER_ROLES.each do |opts|
  UserRole.create(opts)
end
puts "#{UserRole.count} UserRoles"

if Rails.env == 'development'
  # Create some users to fill the db
  Seed::USERS.each do |opts|
    user = User.new(opts)
    user.save
  end
  puts "#{User.count} Users"
  
  #f = Freight.create({
  #  :origin_site_info_attributes => {
  #    :contractor => 'Frachtunternehmen',
  #    :name => "Bochum Hbf",
  #    :address => "Kurt-Schumacher-Platz",
  #    :zip => "44787",
  #    :city => "Bochum",
  #    :country => "Germany",
  #    :date => Time.new,
  #    :side_track_available => true,
  #  },
  #  :destination_site_info_attributes => {
  #    :contractor => 'Frachtunternehmen',
  #    :name => "Dortmund Hbf",
  #    :address => "Bahnhofstr.",
  #    :zip => "44137",
  #    :city => "Dortmund",
  #    :country => "Germany",
  #    :date => Time.new + 1.day,
  #    :side_track_available => true,
  #  },
  #  :weight => 1_000,
  #  :loading_meter => 10,
  #  :hazmat => false,
  #  :transport_type => 'single_wagon',
  #  :wagons_provided_by => 'railway',
  #  :desired_proposal_type => 'package_price',
  #})
  #f.user = User[:freight_supplier]
  #f.company = User[:freight_supplier].company
  #f.save!
  
  puts "#{Freight.count} Freights"
  
  #f = LoadingSpace.create({
  #  :origin_site_info_attributes => {
  #    :contractor => 'Frachtunternehmen',
  #    :name => "Bochum Hbf",
  #    :address => "Kurt-Schumacher-Platz",
  #    :zip => "44787",
  #    :city => "Bochum",
  #    :country => "Germany",
  #    :date => Time.new,
  #    :side_track_available => true,
  #  },
  #  :destination_site_info_attributes => {
  #    :contractor => 'Frachtunternehmen',
  #    :name => "Dortmund Hbf",
  #    :address => "Bahnhofstr.",
  #    :zip => "44137",
  #    :city => "Dortmund",
  #    :country => "Germany",
  #    :date => Time.new + 1.day,
  #    :side_track_available => true,
  #  },
  #  :weight => 1_200,
  #  :loading_meter => 13,
  #  :hazmat => false,
  #  :transport_type => 'single_wagon',
  #})
  #f.user = User[:loading_space_supplier]
  #f.company = User[:loading_space_supplier].company
  #f.save!
  
  puts "#{LoadingSpace.count} LoadingSpaces"
end