class AddAttributesToLoadingSpaces < ActiveRecord::Migration
  def self.up
    add_column :loading_spaces, :contractor, :string
    add_column :loading_spaces, :valid_until, :datetime
    add_column :loading_spaces, :first_transport_at, :datetime
    add_column :loading_spaces, :own_means_of_transport, :string
    add_column :loading_spaces, :own_means_of_transport_custom, :string
    add_column :loading_spaces, :own_means_of_transport_present, :boolean, :default => false
    add_column :loading_spaces, :free_capacities, :string
  end

  def self.down
    remove_column :loading_spaces, :free_capacities
    remove_column :loading_spaces, :own_means_of_transport_present
    remove_column :loading_spaces, :own_means_of_transport_custom
    remove_column :loading_spaces, :own_means_of_transport
    remove_column :loading_spaces, :first_transport_at
    remove_column :loading_spaces, :valid_until
    remove_column :loading_spaces, :contractor
  end
end