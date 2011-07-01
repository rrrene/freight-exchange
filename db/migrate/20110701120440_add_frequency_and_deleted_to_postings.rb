class AddFrequencyAndDeletedToPostings < ActiveRecord::Migration
  TABLES = %w(freights loading_spaces)

  def self.up
    TABLES.each do |table|
      add_column table, :frequency, :string
      add_column table, :deleted, :boolean, :default => false
    end
  end

  def self.down
    TABLES.each do |table|
      remove_column table, :frequency
      remove_column table, :deleted
    end
  end
end
