module NotificationConditionsHelper

  def attribute_name_choices(model)
    const = "#{model}::ATTRIBUTE_NAME_CHOICES".constantize
    const.map { |value|
      label = model.human_attribute_value(:attribute_name, value)
      [label, value]
    }
  end
end
