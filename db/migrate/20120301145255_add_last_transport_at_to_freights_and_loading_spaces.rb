class AddLastTransportAtToFreightsAndLoadingSpaces < ActiveRecord::Migration
  def self.up
    add_column :freights, :last_transport_at, :datetime
    add_column :loading_spaces, :last_transport_at, :datetime
  end

  def self.down
    remove_column :freights, :last_transport_at
    remove_column :loading_spaces, :last_transport_at
  end
end
