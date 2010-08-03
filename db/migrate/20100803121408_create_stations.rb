class CreateStations < ActiveRecord::Migration
  def self.up
    create_table :stations do |t|
      t.string :name
      t.integer :country_id
      t.timestamps
    end
    create_table :regions_stations, :id => false do |t|
      t.integer :region_id
      t.integer :station_id
    end
  end

  def self.down
    drop_table :regions_stations
    drop_table :stations
  end
end
