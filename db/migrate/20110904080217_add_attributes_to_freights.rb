class AddAttributesToFreights < ActiveRecord::Migration
  def self.up
    add_column :freights, :contractor, :string
    add_column :freights, :valid_until, :datetime
    add_column :freights, :product_name, :string
    add_column :freights, :product_state, :string
    add_column :freights, :hazmat_class, :string
    add_column :freights, :un_no, :string
    add_column :freights, :nhm_no, :string
    rename_column :freights, :weight, :total_weight
    add_column :freights, :first_transport_at, :datetime
    add_column :freights, :desired_means_of_transport, :string
    add_column :freights, :desired_means_of_transport_custom, :string
    add_column :freights, :own_means_of_transport, :string
    add_column :freights, :own_means_of_transport_custom, :string
    add_column :freights, :own_means_of_transport_present, :boolean, :default => false
  end

  def self.down
    remove_column :freights, :own_means_of_transport_present
    remove_column :freights, :own_means_of_transport_custom
    remove_column :freights, :own_means_of_transport
    remove_column :freights, :desired_means_of_transport_custom
    remove_column :freights, :desired_means_of_transport
    remove_column :freights, :first_transport_at
    rename_column :freights, :total_weight, :weight
    remove_column :freights, :nhm_no
    remove_column :freights, :un_no
    remove_column :freights, :hazmat_class
    remove_column :freights, :product_state
    remove_column :freights, :product_name
    remove_column :freights, :valid_until
    remove_column :freights, :contractor
  end
end