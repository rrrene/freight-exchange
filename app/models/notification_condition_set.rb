class NotificationConditionSet < ActiveRecord::Base
  belongs_to :company
  belongs_to :user

  has_many :notification_conditions

  validates_presence_of :resource_type
  validates_presence_of :company
  validates_presence_of :user
end
