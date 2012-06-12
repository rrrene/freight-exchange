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

  def self.create_for(company, resource)
    company.users.each do |user|
      create_for_user user, resource
    end
  end

  def self.create_for_user(user, resource)
    n = Notification.create(:user => user)
    n << resource
    n.close!
  end

  validates_associated :user
end
