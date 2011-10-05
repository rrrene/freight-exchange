class AddRequirementFieldsToFreights < ActiveRecord::Migration
  def self.up
    add_column :freights, :requirements_means_of_transport, :text
    add_column :freights, :requirements_at_loading, :text
    add_column :freights, :requirements_at_unloading, :text
  end

  def self.down
    remove_column :freights, :requirements_at_unloading
    remove_column :freights, :requirements_at_loading
    remove_column :freights, :requirements_means_of_transport
  end
end