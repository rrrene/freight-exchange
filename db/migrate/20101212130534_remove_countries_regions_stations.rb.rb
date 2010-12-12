class RemoveCountriesRegionsStations < ActiveRecord::Migration
  def self.up
    drop_table :regions
    drop_table :regions_stations
    drop_table :stations
    drop_table :countries
  end

  def self.down
  end
end
