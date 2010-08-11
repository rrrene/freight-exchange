class CreateFreights < ActiveRecord::Migration
  def self.up
    create_table :freights do |t|
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
      
      t.string :wagons_provided_by # Auftraggeber, Bahn
      
      # misc information as LocalizedInfo
      t.string :desired_proposal_type # Tonnenpreis, Pauschalpreis
      
      # ansprechpartner
      
      t.timestamps
    end
  end

  def self.down
    drop_table :freights
  end
end
