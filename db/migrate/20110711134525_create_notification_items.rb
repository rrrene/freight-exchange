class CreateNotificationItems < ActiveRecord::Migration
  def self.up
    create_table :notification_items do |t|
      t.references :user
      t.references :notification
      t.references :item, :polymorphic => true
      t.timestamps
    end
  end

  def self.down
    drop_table :notification_items
  end
end
