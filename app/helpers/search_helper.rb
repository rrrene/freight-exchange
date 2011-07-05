module SearchHelper

  def contextual_search_path
    {:controller => contextual_search_controller, :action => :index}
  end

  def contextual_search_controller
    if action_name != 'dashboard'
      if %w(freights loading_spaces companies).include?(controller_name)
        return controller_name
      end
    end
    'freights'
  end

  def search_input_is(object, field, opts = {})
    opts.merge!(:keyword => :is)
    name = name_from_object_and_field(object, field, opts)
    collection = opts[:collection].map { |key| key.is_a?(Array) ? key : [t("search.advanced.collection.#{field}.#{key}"), key] }
    content = content_tag(:select, options_for_select(collection), :name => name)
    content = wrap_search_input(field, content, opts).html_safe
    content
  end
  
  def search_input_from_to(object, field, opts = {}, *rest)
    search_input_from_to_wrapper(object, field, opts.reverse_merge(:keyword => :from)) +
      search_input_from_to_wrapper(object, field, opts.reverse_merge(:keyword => :to))
  end
  
  def search_input_from_to_wrapper(object, field, opts = {}, *rest)
    name = name_from_object_and_field(object, field, opts)
    content = if field == :date
      date = opts[:keyword] == :to ? Date.current + 1.year : Date.current
      %w(year month day).map { |identifier| 
        method("select_#{identifier}").call(date, {}, {:name => name + "[#{identifier}]"})
      }.join(' ').html_safe
    else
      content = text_field_tag(name, nil, :size => 50)
    end
    wrap_search_input(field, content, opts)
  end
  
  def search_input_contains(object, field, opts = {}, *rest)
    opts.merge!(:keyword => :contains)
    name = name_from_object_and_field(object, field, opts)
    value = value_from_object_and_field(object, field, opts)
    content = text_field_tag(name, value, :size => 50)
    wrap_search_input(field, content, opts)
  end
  
  def search_localized_info_field(field, opts = {}, *rest)
    object = :localized_infos
    opts.merge!(:keyword => :contains)
    name = name_from_object_and_field(object, field, opts)
    content = text_field_tag(name, nil, :size => 50)
    wrap_search_input(field, content, opts)
  end
  
  def yes_no_collection 
    [[t("common.choice_yes"), true], [t("common.choice_no"), false]]
  end
  
  def include_blank(collection)
    [[t("common.choose"), '']] + collection
  end
  
  private
  
  def name_from_object_and_field(object, field, opts)
    arr = [opts[:keyword], object, field].compact
    arr.shift.to_s + arr.map { |f| "[#{f}]" }.join
  end
  
  def value_from_object_and_field(object, field, opts)
    if base = params[opts[:keyword]]
      base = base[object] unless object.nil?
      base = base[field]
    end
  end
  
  def wrap_search_input(field, content, opts = {})
    lbl = label_tag(field, label_text(field, content, opts))
    content_tag(:li, lbl << ' ' << content, :class => opts[:class] || :string)
  end
  
  def label_text(field, content, opts = {})
    # this is an evil hack. general fields such as weight are wrongfully supposed to be in :destination
    site = content.to_s =~ /origin/ ? :origin : :destination
    field_translation = t("search.advanced.#{site}.fields.#{field}")
    keyword_translation = t("search.advanced.keyword_#{opts[:keyword]}")
    field_translation.html_safe << keyword_translation.full? { |f| " (#{f})" }.to_s
  end
  
end
