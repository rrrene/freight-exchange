class NotificationConditionFreight < NotificationCondition
  ATTRIBUTE_NAME_CHOICES = NotificationCondition::ATTRIBUTE_NAME_CHOICES + %w(product_name product_state hazmat nhm_no total_weight)
  QUALIFIER_CHOICES = NotificationCondition::QUALIFIER_CHOICES
end
