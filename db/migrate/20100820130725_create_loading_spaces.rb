class CreateLoadingSpaces < ActiveRecord::Migration
  def self.up
    create_table :loading_spaces do |t|
      t.integer :user_id
      t.integer :company_id
      
      t.integer :origin_site_info_id
      t.integer :destination_site_info_id
      
      t.integer :weight
      t.integer :loading_meter
      
      # type of goods as LocalizedInfo
      t.boolean :hazmat # hazardous material
      
      t.string :transport_type # Einzelwagen (single wagon), Wagengruppen (train set) und Ganzzüge (block train)
      # transport description as LocalizedInfo
      
      # ansprechpartner
      
      t.timestamps
    end
  end

  def self.down
    drop_table :loading_spaces
  end
end
