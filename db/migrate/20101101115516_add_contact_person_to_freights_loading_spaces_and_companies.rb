class AddContactPersonToFreightsLoadingSpacesAndCompanies < ActiveRecord::Migration
  def self.up
    remove_column :companies, :contact_person
    add_column :companies, :contact_person_id, :integer
    add_column :freights, :contact_person_id, :integer
    add_column :loading_spaces, :contact_person_id, :integer
  end

  def self.down
    add_column :companies, :contact_person, :string
    remove_column :companies, :contact_person_id
    remove_column :freights, :contact_person_id
    remove_column :loading_spaces, :contact_person_id
  end
end
