class CreatePostings < ActiveRecord::Migration
  def self.up
    create_table :postings do |t|
      t.string :type
      t.integer :user_id
      
      t.string :origin_contractor
      t.string :destination_contractor
      
      t.integer :origin_station_id
      t.integer :destination_station_id
      
      t.datetime :origin_date
      t.datetime :destination_date
      
      t.text :goods_type
      t.string :wagon_type
      t.text :wagon_text # has to be localizable
      
      t.integer :loading_meter
      t.integer :weight
      
      t.text :misc_text # has to be localizable
      
      t.timestamps
    end
  end

  def self.down
    drop_table :postings
  end
end
