class RemoveMiscFromCompanies < ActiveRecord::Migration
  def self.up
    remove_column :companies, :misc
  end

  def self.down
    add_column :companies, :misc, :text
  end
end
