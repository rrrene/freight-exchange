class AddPostingTypeToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :posting_type, :string, :default => 'Freight'
  end

  def self.down
    remove_column :users, :posting_type
  end
end
