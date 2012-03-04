class NotificationCondition < ActiveRecord::Base
  belongs_to :notification_condition_set

  RESOURCE_TYPE_CHOICES = %w(LoadingSpace Freight)
  ATTRIBUTE_NAME_CHOICES = %w(origin_city destination_city frequency)
  QUALIFIER_CHOICES = %w(equal)

  validates_presence_of :notification_condition_set
  validates_presence_of :attribute_name
  validates_presence_of :qualifier
end
