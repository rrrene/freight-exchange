require File.join(File.dirname(__FILE__), 'seed_data') 

[Station].each do |model|
  Dir["#{Rails.root}/db/seeds/#{model.to_s.tableize}/*.csv"].each do |f|
    puts "Opening: #{File.basename(f)}"
    @read_headers = false
    FasterCSV.foreach(f) do |row|
      resource = model.new
      if @read_headers
        row.each_with_index do |value, index|
          attr = @headers[index]
          resource[attr] = value
        end
      else
        @headers = row
        @read_headers = true
        puts "headers: #{@headers.inspect}"
      end

      begin
        resource.save
        print "."
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

# Create basic company roles
Seed::COMPANY_ROLES.each do |opts|
  CompanyRole.create(opts)
end

if Rails.env == 'development'
  # Create some users to fill the db
  Seed::USERS.each do |opts|
    user = User.new(opts)
    user.save
  end
end

[UserRole, CompanyRole, Station, Freight, LoadingSpace].each do |model|
  puts model.count.to_s.rjust(5) + " " + model.to_s.pluralize
end