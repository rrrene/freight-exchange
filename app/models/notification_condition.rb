class NotificationCondition < ActiveRecord::Base
  belongs_to :notification_condition_set

  ATTRIBUTE_NAME_CHOICES = %w(origin_city destination_city frequency first_transport_at)
  QUALIFIER_CHOICES = %w(equal)

  validates_presence_of :notification_condition_set
  validates_presence_of :attribute_name
  validates_presence_of :qualifier
end
