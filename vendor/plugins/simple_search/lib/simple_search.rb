# SimpleSearch
class SimpleSearch < ActiveRecord::Base
  belongs_to :item, :polymorphic => true
  
  class << self
    def create_or_update(model_or_record)
      if model_or_record.is_a_or_an_array_of?(ActiveRecord::Base)
        records = [model_or_record].flatten
        records.each do |record|
          create_or_update_item(record)
        end
      else
        models = [model_or_record].flatten
        models.each do |model|
          model.all.each do |record|
            create_or_update_item(record)
          end
        end
      end
    end
    alias << create_or_update
    
    def create_or_update_item(item = nil)
      return if item.blank?
      if record = self.where(['item_type = ? AND item_id = ?', item.class.to_s, item.id]).first
        record.update_attribute(:text, text_for(item))
      else
        record = self.create(:item => item, :text => text_for(item))
      end
    end
    
    def clear_item(item = nil)
      destroy_all(['item_type = ? AND item_id = ?', item.class.to_s, item.id])
    end
    
    def text_for(item)
      item.respond_to?(:to_search) ? item.to_search : item.to_s
    end
    
    def search(query)
      words = query.to_s.split(' ')
      words.inject(self) { |chain, word| 
        chain.where(['text LIKE ?', '%' << word << '%'])  
      }.all.map(&:item)
    end
    alias / search
  end
end
