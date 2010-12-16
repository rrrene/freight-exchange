class RemoveCountriesRegionsStations < ActiveRecord::Migration
  def self.up
    # rails destroy model region has removed the original creation scripts from db/migrate
    # i.e. rake db:migrate does no longer create them in the first place on a fresh install
    # therefore try to drop the tables if they exist, but do not let the migration fail, 
    # if they do not.
    try_to_drop_table :regions
    try_to_drop_table :regions_stations
    try_to_drop_table :stations
    try_to_drop_table :countries
  end

  def self.down
  end
  
  def self.try_to_drop_table(table)
    begin
      drop_table table
    rescue
    end
  end
end
