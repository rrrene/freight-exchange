class CreateStations < ActiveRecord::Migration
  def self.up
    create_table :stations do |t|
      t.string :name
      t.string :numeric_id
      
      t.text :searchable

      t.string :address
      t.string :address2
      t.string :zip
      t.string :city
      t.string :country
      
      t.timestamps
    end
  end

  def self.down
    drop_table :stations
  end
end
