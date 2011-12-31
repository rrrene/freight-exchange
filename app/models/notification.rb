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
    if user.notify_by_email?
      UserNotifier.notification(user, self).deliver
    end
  end

  validates_associated :user
end
