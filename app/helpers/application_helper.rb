# The ApplicationHelper provides basic helper methods for all views.
module ApplicationHelper
  # Returns <tt>true</tt> if the current controller is an Admin::BaseController
  def admin?
    controller.is_a?(Admin::BaseController)
  end
  
  def box(title = nil, &block)
    inner = capture(&block)
    head = title.full? { |t| content_tag :h3, t }.to_s
    content_tag(:div, head << inner, :class => 'box')
  end
  
  # Returns a DIV tag that clears floating.
  def clear_both
    '<div style="clear:both"></div>'.html_safe
  end
  
  # Returns the collection of localized choices for a given attribute.
  # Example:
  #   collection_choices(Person, :gender)
  #
  # This will look up <tt>Person::GENDER_CHOICES</tt> and return the keys and
  # localized values.
  def collection_choices(model, attribute_name, const = nil)
    const ||= "#{model}::#{attribute_name.to_s.upcase}_CHOICES".constantize
    const.map { |value| 
      [model.human_attribute_value(attribute_name, value), value] 
    }
  end
  
  #:call-seq:
  #   controller?(name) # => boolean
  #
  # Returns if c is the current controller.
  # Example:
  #   <%= controller?(:root) %>
  #   # => true
  def controller?(name)
    controller.controller_name == name
  end
  
  # Returns a HTML formatted version of <tt>text</tt>.
  # Example:
  #   <%= format_multiline_input("First line.\nSecond Line.") %>
  #   # => "First line.<br>Second line."
  def format_multiline_input(text)
    simple_format(h(text)).html_safe
  end
  
  def humanize_recording(rec)
    opts = {
      :user => rec.user.full?(&:name),
      :object_class => rec.item.full?(&:class),
      :object_link => link_to_item(rec.item),
    }
    t("recordings.#{rec.action}", opts)
  end
  
  def link_btn(text, path, opts = {})
    if icon = opts.delete(:icon)
      text = content_tag(:span, "", :class => 'icon') << text
    end
    text = content_tag(:span, text)
    opts[:class] = [
        :minibutton, 
        opts[:class].full? ? opts[:class] : icon.full?, 
        icon.full? { |i| "btn-#{i}" }
      ].compact.join(' ')
    link_to text, path, opts
  end
  
  def link_to_item(item)
    return t("common.deleted_object") if item.blank?
    text = item.respond_to?(:name) ? item.name : item.to_s
    link_to(text, item)
  rescue
    text
  end
  
  # Returns a link back to the last visited page with a localized caption.
  def link_back(text = t("common.link_back"))
    link_to_function text, "self.history.back();", :class => 'back'
  end
  
  def link_to_result(t, result)
    url_method = method(result.class.to_s.underscore << '_path')
    url = url_method.call(:id => result, :search_recording_id => @search_recording.full?(&:id))
    link_to(t, url)
  end
  
  # TODO: lookup rails3 implementation
  def link_to_unless(condition, name, options = {}, html_options = {}, &block)
    condition ? content_tag(:span, name, html_options) : link_to(name, options, html_options, &block)
  end
  
  # Returns a formatted string for the associated LocalizedInfo object.
  def localized_info(obj, name, lang = I18n.default_locale)
    text = obj.localized_info(name, lang).text
    format_multiline_input(text) if text.full?
  end
  
  #  TODO: localized_info_field f, :type_of_goods, :en
  # BETTER: f.localized_info_field :type_of_goods, :en
  def localized_info_field(f, name, lang = current_person.locale)
    render({:partial => '/partials/localized_info_form_content',
              :locals => {:f => f, :name => name, :lang => lang}})
  end
  
  def only_some_attributes_filled?(ar)
    ar.attributes_filled < AppConfig['contact_info.complete_percentage'].to_f
  end
  
  def posting_freights?
    current_user.full?(&:posting_type) == 'Freight'
  end
  
  # Renders a partial with the contact information for the given company.
  # Example:
  #   <%= render_person_info current_company %>
  def render_company_info(company = resource.company)
    render_partial :sidebar_company_info, :locals => {:company => company}
  end
  
  def render_partial(partial, options = {})
    subs = current_user.roles
    subs << :admin if admin?
    render options.merge(:partial => search_for_partial(subs, partial))
  end

  def review_badge
    count = current_company.unapproved_reviews.count
    if count > 0
      ' ' << content_tag(:span, count, :class => 'badge')
    else
      ""
    end
  end
  
  def search_for_partial(sub_dirs, partial)
    sub_dirs.each do |sub_dir|
      if template_exists?("/partials/#{sub_dir}/_#{partial}")
        return "/partials/#{sub_dir}/#{partial}"
      end
    end
    "/partials/#{partial}"
  end
  
  # Renders a partial with the contact information for the given person.
  # Example:
  #   <%= render_person_info current_person %>
  def render_person_info(person)
    render_partial :sidebar_person_info, :locals => {:person => person}
  end
  
  def yes_no(condition)
    condition ? t("common.choice_yes") : t("common.choice_no")
  end
  
end
