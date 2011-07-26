class AddReplyToToPostings < ActiveRecord::Migration
  def self.up
    add_column :freights, :reply_to_id, :integer
    add_column :loading_spaces, :reply_to_id, :integer
  end

  def self.down
    remove_column :loading_spaces, :reply_to_id
    remove_column :freights, :reply_to_id
  end
end