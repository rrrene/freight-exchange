class RemoveRecordingsTable < ActiveRecord::Migration
  def self.up
    drop_table :recordings
  rescue
  end

  def self.down
  end
end
