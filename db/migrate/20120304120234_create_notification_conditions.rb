class CreateNotificationConditions < ActiveRecord::Migration
  def self.up
    create_table :notification_conditions do |t|
      t.integer :notification_condition_set_id

      t.string :attribute_name
      t.string :qualifier, :default => "equal"
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :notification_conditions
  end
end
