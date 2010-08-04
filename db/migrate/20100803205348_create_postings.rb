class CreatePostings < ActiveRecord::Migration
  def self.up
    create_table :postings do |t|
      t.string :type
      t.integer :user_id
      t.integer :origin_station_id
      t.integer :destination_station_id
      t.datetime :origin_date
      t.datetime :destination_date

      t.string :goods_type
      t.string :wagon_type

      t.integer :loading_meter
      t.integer :weight

      t.string :contractor
      t.text :misc

      t.timestamps
    end
  end

  def self.down
    drop_table :postings
  end
end
