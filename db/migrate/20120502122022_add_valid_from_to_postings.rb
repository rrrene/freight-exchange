class AddValidFromToPostings < ActiveRecord::Migration
  MODELS = [Freight, LoadingSpace]
  
  def self.up
    MODELS.each do |model|
      add_column model.to_s.underscore.tableize, :valid_from, :datetime
      model.reset_column_information
      model.update_all(:valid_from => 1.year.ago)
    end
  end

  def self.down
    MODELS.each do |model|
      remove_column model.to_s.underscore.tableize, :valid_from
    end
  end
end