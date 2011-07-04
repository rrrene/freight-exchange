class BlackListedItem < ActiveRecord::Base
  ITEM_CHOICES = %w(Company)
  belongs_to :company
  belongs_to :item, :polymorphic => true

  validates_inclusion_of :item_type, :in => ITEM_CHOICES
  validates_presence_of :item_id
end
