class AddStationIdToSiteInfos < ActiveRecord::Migration
  def self.up
    add_column :site_infos, :station_id, :integer
  end

  def self.down
    remove_column :site_infos, :station_id
  end
end