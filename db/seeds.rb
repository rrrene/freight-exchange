# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


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