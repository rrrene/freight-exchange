class Notification < ActiveRecord::Base
  belongs_to :user
  has_many :notification_items, :dependent => :destroy
  
  def <<(item)
    record = notification_items.new
    record.user = user
    record.item = item
    record.save
    record
  end

  def closed?
    !closed_at.blank?
  end

  def close!
    self.closed_at = Time.now
    save!
  end

  def viewed!
    self.viewed = true
    save!
  end
  
  validates_associated :user
end
