module ApplicationHelper
  
  def box(title = nil, &block)
    inner = capture(&block)
    head = title.full? { |t| content_tag :h3, t }.to_s
    content_tag(:div, head << inner, :class => 'box')
  end
  
  def clear_both
    '<div style="clear:both"></div>'.html_safe
  end
  
  def collection_choices(model, attribute_name, const = nil)
    const ||= "#{model}::#{attribute_name.to_s.upcase}_CHOICES".constantize
    const.map { |value| 
      [model.human_attribute_value(attribute_name, value), value] 
    }
  end
  
  def controller?(c)
    controller.controller_name == c
  end
  
  def format_multiline_input(text)
    text
  end
  
  def link_back(text = t("common.link_back"))
    link_to_function text, "self.history.back();", :class => 'back'
  end
  
  # TODO: lookup rails3 implementation
  def link_to_unless(condition, name, options = {}, html_options = {}, &block)
    condition ? content_tag(:span, name, html_options) : link_to(name, options, html_options, &block)
  end
  
  def localized_info(obj, name, lang = I18n.default_locale)
    format_multiline_input obj.localized_info(name, lang).text
  end
  
  #  TODO: localized_info_field f, :type_of_goods, :en
  # BETTA: f.localized_info_field :type_of_goods, :en
  def localized_info_field(f, name, lang)
    render({:partial => '/partials/localized_info_form_content',
              :locals => {:f => f, :name => name, :lang => lang}})
  end
  
  def only_some_attributes_filled?(ar)
    ar.attributes_filled < 0.5
  end
  
  def render_company_info(company)
    render :partial => "/partials/sidebar_company_info", :locals => {:company => company}
  end
  
  def render_table(arel)
    render :partial => '/partials/table', :locals => {:model => arel.first.class, :arel => arel}
  end
  
  def yes_no(condition)
    condition ? t("common.choice_yes") : t("common.choice_no")
  end
  
end
