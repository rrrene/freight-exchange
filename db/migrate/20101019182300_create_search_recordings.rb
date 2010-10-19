class CreateSearchRecordings < ActiveRecord::Migration
  def self.up
    create_table :search_recordings do |t|
      t.integer :user_id
      t.string  :query
      t.integer :results
      t.integer :parent_id
      t.string  :result_type, :limit => 30
      t.integer :result_id
      t.timestamps
    end
  end

  def self.down
    drop_table :search_recordings
  end
end
