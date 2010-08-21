class CreateSiteInfos < ActiveRecord::Migration
  def self.up
    create_table :site_infos do |t|
      t.string :contractor
      t.datetime :date
      t.string :name
      t.string :address
      t.string :address2
      t.string :zip
      t.string :city
      t.string :country
      t.boolean :side_track_available
      t.string :track_number
      t.timestamps
    end
    add_column :stations, :address, :string
    add_column :stations, :address2, :string
    add_column :stations, :zip, :string
    add_column :stations, :city, :string
  end

  def self.down
    remove_column :stations, :city
    remove_column :stations, :zip
    remove_column :stations, :address2
    remove_column :stations, :address
    drop_table :site_infos
  end
end
