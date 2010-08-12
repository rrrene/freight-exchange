class LocalizedInfo < ActiveRecord::Base
  belongs_to :item, :polymorphic => true
  
  validates_presence_of :name
  validates_presence_of :lang
  validates_presence_of :text
end
