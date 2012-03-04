module PostingsHelper

  def posting_html_classes(ar)
    classes = []
    classes << if ar.try(:valid_until).to_i < Time.now.to_i
      :old
    else
      :new
    end
    if @highlight && @highlight.include?(ar.id.to_s)
      classes << "highlight"
    end
    if white_listed?(ar.company)
      classes << "white_listed"
    end
    classes * " "
  end

  def posting_attribute(attribute, opts = {})
    name = resource_class.human_attribute_name(attribute)
    value = value_for_attribute attribute, opts
    history = attribute_history(attribute, opts)
    if value.full? || history.full?
      render :partial => "postings/show_attribute", :locals => {:history => history, :attribute => attribute, :name => name, :value => value, :dependent => !!opts[:dependent]}
    end
  end

  def attribute_history(attribute, opts = {})
    return nil if @history.blank?
    current = nil
    history = []
    @history.each do |item|
      new_value = item[attribute]
      if new_value != current
        history << {:before => current.nil? ? nil : value_for_attribute(attribute, opts, current), :after => value_for_attribute(attribute, opts, new_value), :item => item}
      end
      current = new_value
    end
    history.full?
  end

  def value_for_attribute(attribute, opts = {}, value = nil)
    value ||= resource.send(attribute)
    if opts[:humanize]
      value = resource_class.human_attribute_value(attribute, value)
    end
    if opts[:localize] || value.is_a?(Time)
      value = l(value)
    end
    if [true, false].include?(value)
      value = value ? t("common.choice_yes") : t("common.choice_no")
    end
    value
  end

end
