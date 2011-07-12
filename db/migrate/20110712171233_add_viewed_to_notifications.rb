class AddViewedToNotifications < ActiveRecord::Migration
  def self.up
    add_column :notifications, :viewed, :boolean, :default => false
  end

  def self.down
    remove_column :notifications, :viewed
  end
end