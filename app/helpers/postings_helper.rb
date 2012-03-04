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
    parent_values = parent_values_for(attribute, opts).full?
    if value || parent_values
      render :partial => "postings/show_attribute", :locals => {:name => name, :value => value, :parent_values => parent_values, :dependent => !!opts[:dependent]}
    end
  end

  def value_for_attribute(attribute, opts = {}, value = nil)
    value ||= resource.send(attribute)
    if opts[:humanize]
      value = resource.human_attribute_value(attribute)
    end
    if opts[:localize] || value.is_a?(DateTime)
      value = l(value)
    end
    if [true, false].include?(value)
      value = value ? t("common.choice_yes") : t("common.choice_no")
    end
    value
  end

  def parent_values_for(attribute, opts)
    if @parents
      compare_to = resource
      @parents.map do |parent|
        if parent[attribute] != compare_to[attribute]
          compare_to = parent
          value_for_attribute attribute, opts, parent[attribute]
        else
          compare_to = parent
          nil
        end
      end
    end
  end
end
