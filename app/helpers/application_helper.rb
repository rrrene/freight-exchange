module ApplicationHelper
  
  def box(title = nil, &block)
    inner = capture(&block)
    head = title.full? { |t| content_tag :h3, t }.to_s
    content_tag(:div, head << inner, :class => 'box')
  end
  
  def clear_both
    '<div style="clear:both"></div>'.html_safe
  end
  
  def controller?(c)
    controller.controller_name == c
  end
  
  # TODO: lookup rails3 implementation
  def link_to_unless(condition, name, options = {}, html_options = {}, &block)
    condition ? content_tag(:span, name, html_options) : link_to(name, options, html_options, &block)
  end
  
end
