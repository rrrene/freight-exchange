class AddUserAndCompanyToRecordings < ActiveRecord::Migration
  def self.up
    add_column :recordings, :user_id, :integer
    add_column :recordings, :company_id, :integer
  end

  def self.down
    remove_column :recordings, :company_id
    remove_column :recordings, :user_id
  end
end
