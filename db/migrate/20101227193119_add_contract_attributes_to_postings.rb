class AddContractAttributesToPostings < ActiveRecord::Migration
  @@tables = %w(freights loading_spaces)
  def self.up
    @@tables.each do |table|
      add_column table, :transport_weight, :integer
      add_column table, :transports_per_year, :integer
      add_column table, :paying_freight, :string, :default => "sender"
    end
  end

  def self.down
    @@tables.each do |table|
      remove_column table, :transports_per_year
      remove_column table, :transport_weight
      remove_column table, :paying_freight
    end
  end
end