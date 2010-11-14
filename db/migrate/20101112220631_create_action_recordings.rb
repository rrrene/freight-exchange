class CreateActionRecordings < ActiveRecord::Migration
  def self.up
    create_table :action_recordings do |t|
      t.string    :item_type, :limit => 30
      t.integer   :item_id
      t.string    :action, :limit => 10 #create, update, destroy
      t.text      :diff
      t.integer   :user_id
      t.integer   :company_id
      t.timestamps
    end
  end

  def self.down
    drop_table :action_recordings
  end
end
