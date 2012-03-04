class CreateNotificationConditionSets < ActiveRecord::Migration
  def self.up
    create_table :notification_condition_sets do |t|
      t.integer :company_id
      t.integer :user_id

      t.string :resource_type

      t.timestamps
    end
  end

  def self.down
    drop_table :notification_condition_sets
  end
end
