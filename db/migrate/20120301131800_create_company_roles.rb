class CreateCompanyRoles < ActiveRecord::Migration
  def self.up
    create_table :company_roles do |t|
      t.string :name
      t.timestamps
    end
    create_table :companies_company_roles, :id => false do |t|
      t.integer :company_id
      t.integer :company_role_id
    end
    create_table :company_roles_freights, :id => false do |t|
      t.integer :freight_id
      t.integer :company_role_id
    end
    create_table :company_roles_loading_spaces, :id => false do |t|
      t.integer :loading_space_id
      t.integer :company_role_id
    end
    add_column :companies, :custom_category, :string
    add_column :freights, :custom_category, :string
    add_column :loading_spaces, :custom_category, :string
  end

  def self.down
    remove_column :companies, :custom_category
    remove_column :freights, :custom_category
    remove_column :loading_spaces, :custom_category
    drop_table :company_roles_freights
    drop_table :company_roles_loading_spaces
    drop_table :companies_company_roles
    drop_table :company_roles
  end
end
