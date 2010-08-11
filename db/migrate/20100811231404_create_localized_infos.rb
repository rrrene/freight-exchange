class CreateLocalizedInfos < ActiveRecord::Migration
  def self.up
    create_table :localized_infos do |t|
      t.string :item_type
      t.integer :item_id
      t.string :name
      t.string :lang
      t.text :text
      t.timestamps
    end
  end

  def self.down
    drop_table :localized_infos
  end
end
