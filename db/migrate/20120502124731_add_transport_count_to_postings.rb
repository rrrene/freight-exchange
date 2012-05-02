class AddTransportCountToPostings < ActiveRecord::Migration
  MODELS = [Freight, LoadingSpace]

  def self.up
    MODELS.each do |model|
      add_column model.to_s.underscore.tableize, :transport_count, :integer, :default => 1
    end
  end

  def self.down
    MODELS.each do |model|
      remove_column model.to_s.underscore.tableize, :transport_count
    end
  end
end
