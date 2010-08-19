class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.string :job_description
      t.string :phone
      t.string :fax
      t.string :mobile
      t.string :email
      t.string :website
      t.string :locale, :default => 'en'
      t.timestamps
    end
    add_column :users, :person_id, :integer
  end

  def self.down
    remove_column :users, :person_id
    drop_table :people
  end
end
