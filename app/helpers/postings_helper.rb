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
    value = resource.send(attribute)
    if opts[:humanize]
      value = resource.human_attribute_value(attribute)
    end
    if opts[:localize] || value.is_a?(DateTime)
      value = l(value)
    end
    if [true, false].include?(value)
      value = value ? t("common.choice_yes") : t("common.choice_no")
    end
    if value
      render :partial => "postings/show_attribute", :locals => {:name => name, :value => value, :dependent => !!opts[:dependent]}
    end
  end
end
