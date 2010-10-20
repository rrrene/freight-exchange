class CreateMatchingRecordings < ActiveRecord::Migration
  def self.up
    create_table :matching_recordings do |t|
      t.string  :a_type, :limit => 30
      t.integer :a_id
      t.string  :b_type, :limit => 30
      t.integer :b_id
      t.float   :result
      t.timestamps
    end
  end

  def self.down
    drop_table :matching_recordings
  end
end
