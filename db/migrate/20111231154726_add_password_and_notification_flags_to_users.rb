class AddPasswordAndNotificationFlagsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :password_reset_key, :string
    add_column :users, :notify_by_email, :boolean, :default => false
  end

  def self.down
    remove_column :users, :password_reset_key
    remove_column :users, :notify_by_email
  end
end
