class MoveViewedColumnToNotificationItems < ActiveRecord::Migration
  def self.up
    add_column :notification_items, :viewed, :boolean, :default => false
    remove_column :notifications, :viewed
  end

  def self.down
    add_column :notifications, :viewed, :boolean,     :default => false
    remove_column :notification_items, :viewed
  end
end
