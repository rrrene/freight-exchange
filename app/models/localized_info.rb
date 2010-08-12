class LocalizedInfo < ActiveRecord::Base
  belongs_to :item, :polymorphic => true
  
  def update_or_destroy!
    text.blank? ? destroy : save
  end
  
  validates_presence_of :name
  validates_presence_of :lang
  validates_presence_of :text
end
