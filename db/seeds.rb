require File.join(File.dirname(__FILE__), 'seed_data') 

[Station].each do |model|
  Dir["#{Rails.root}/db/seeds/#{model.to_s.tableize}*.csv"].each do |f|
    puts f
    @read_headers = false
    FasterCSV.foreach(f, :col_sep => ";") do |row|
      resource = model.new
      if @read_headers
        row.each_with_index do |value, index|
          attr = @headers[index]
          resource[attr] = value
        end
      else
        @headers = row
        @read_headers = true
        puts "headers: #{@headers}"
      end

      begin
        resource.save
      rescue
        warn resource.inspect
      end

    end
  end
end

# Create basic user roles
Seed::USER_ROLES.each do |opts|
  UserRole.create(opts)
end

if Rails.env == 'development'
  # Create some users to fill the db
  Seed::USERS.each do |opts|
    user = User.new(opts)
    user.save
  end
  
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

end

[UserRole, Station, Freight, LoadingSpace].each do |model|
  puts model.count.to_s.rjust(5) + " " + model.to_s.pluralize
end