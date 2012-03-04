class AddParentIdToPostings < ActiveRecord::Migration
  def self.up
    add_column :freights, :parent_id, :integer
    add_column :loading_spaces, :parent_id, :integer
  end

  def self.down
    remove_column :freights, :parent_id
    remove_column :loading_spaces, :parent_id
  end
end
