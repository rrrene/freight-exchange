class CreateSimpleSearches < ActiveRecord::Migration
  def self.up
    create_table :simple_searches do |t|
      t.string  :item_type
      t.integer :item_id
      t.text    :text
      t.timestamps
    end
  end

  def self.down
    drop_table :simple_searches
  end
end
