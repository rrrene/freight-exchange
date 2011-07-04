class AddCommercialInfoToCompanies < ActiveRecord::Migration
  def self.up
    add_column :companies, :commercial_register_entry, :string
    add_column :companies, :vat_id, :string
  end

  def self.down
    remove_column :companies, :commercial_register_entry
    remove_column :companies, :vat_id
  end
end
