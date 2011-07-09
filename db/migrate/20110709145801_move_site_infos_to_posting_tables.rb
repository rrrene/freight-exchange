class MoveSiteInfosToPostingTables < ActiveRecord::Migration
  MODELS = [Freight, LoadingSpace]
  FIELDS = %w(origin destination)
  def self.up
    MODELS.each do |model|
      table = model.table_name
      FIELDS.each do |origin_or_destination|
        puts "migrating #{table} #{origin_or_destination}"
        add_column table, :"#{origin_or_destination}_station_id", :integer
        add_column table, :"#{origin_or_destination}_contractor", :string
        add_column table, :"#{origin_or_destination}_name", :string
        add_column table, :"#{origin_or_destination}_address", :string
        add_column table, :"#{origin_or_destination}_address2", :string
        add_column table, :"#{origin_or_destination}_zip", :string
        add_column table, :"#{origin_or_destination}_city", :string
        add_column table, :"#{origin_or_destination}_country", :string
        add_column table, :"#{origin_or_destination}_side_track_available", :boolean
        add_column table, :"#{origin_or_destination}_track_number", :string
        
        #attributes = %w(station_id contractor address address2 zip city country side_track_available track_number)
        #model.all.each do |record|
        #  attributes.each do |attr|
        #    site_info = record.__send__(:"#{origin_or_destination}_site_info")
        #    record[:"#{origin_or_destination}_#{attr}"] = site_info[attr]
        #  end
        #  puts record.inspect
        #  record.save
        #  puts "  saved record##{record.id}"
        #end
      end
    end
  end

  def self.down
    MODELS.each do |model|
      table = model.table_name
      FIELDS.each do |origin_or_destination|
        remove_column table, :"#{origin_or_destination}_track_number"
        remove_column table, :"#{origin_or_destination}_contractor"
        remove_column table, :"#{origin_or_destination}_side_track_available"
        remove_column table, :"#{origin_or_destination}_country"
        remove_column table, :"#{origin_or_destination}_city"
        remove_column table, :"#{origin_or_destination}_zip"
        remove_column table, :"#{origin_or_destination}_address2"
        remove_column table, :"#{origin_or_destination}_address"
        remove_column table, :"#{origin_or_destination}_name"
        remove_column table, :"#{origin_or_destination}_station_id"
      end
    end
  end
end