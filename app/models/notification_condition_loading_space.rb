class NotificationConditionLoadingSpace < NotificationCondition
  ATTRIBUTE_NAME_CHOICES = NotificationCondition::ATTRIBUTE_NAME_CHOICES + %w(own_means_of_transport)
  QUALIFIER_CHOICES = NotificationCondition::QUALIFIER_CHOICES
end
