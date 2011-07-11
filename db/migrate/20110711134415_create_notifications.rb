class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.references :user
      t.boolean :sent, :default => false
      t.datetime :closed_at
      t.timestamps
    end
  end

  def self.down
    drop_table :notifications
  end
end
