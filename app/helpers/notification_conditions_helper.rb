module NotificationConditionsHelper

  def attribute_name_choices(model, posting_model)
    const = "#{model}::ATTRIBUTE_NAME_CHOICES".constantize
    const.map { |value|
      label = posting_model.human_attribute_name(value)
      [label, value]
    }
  end
end
