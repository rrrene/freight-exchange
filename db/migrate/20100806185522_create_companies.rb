class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :name
      t.string :contact_person
      t.string :phone
      t.string :fax
      t.string :mobile
      t.string :email
      t.string :website
      t.string :address
      t.string :address2
      t.string :zip
      t.string :city
      t.string :country
      t.text :misc
      t.timestamps
    end
    add_column :users, :company_id, :integer
  end

  def self.down
    remove_column :users, :company_id
    drop_table :companies
  end
end
