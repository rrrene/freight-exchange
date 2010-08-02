class CreateRecordings < ActiveRecord::Migration
  def self.up
    create_table :recordings do |t|
      t.string    :item_type, :limit => 30
      t.integer   :item_id
      t.string    :action, :limit => 10 #create, update, destroy
      t.text      :diff
      t.timestamps
    end
  end

  def self.down
    drop_table :recordings
  end
end
