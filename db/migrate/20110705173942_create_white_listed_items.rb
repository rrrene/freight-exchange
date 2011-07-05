class CreateWhiteListedItems < ActiveRecord::Migration
  def self.up
    create_table :white_listed_items do |t|
      t.references :company
      t.references :item, :polymorphic => true
      t.timestamps
    end
  end

  def self.down
    drop_table :white_listed_items
  end
end
