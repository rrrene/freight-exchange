class NotificationItem < ActiveRecord::Base
  ITEM_TYPE_CHOICES = %w(Freight LoadingSpace Review)
  belongs_to :notification
  belongs_to :user
  belongs_to :item, :polymorphic => true
  
  def viewed!
    self.viewed = true
    save!
  end

  validates_associated :user
  validates_associated :item
  validates_inclusion_of :item_type, :in => ITEM_TYPE_CHOICES
  validates_uniqueness_of :item_id, :scope => [:notification_id, :item_type]
end
