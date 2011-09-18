# The ApplicationHelper provides basic helper methods for all views.
module ApplicationHelper
  # Returns <tt>true</tt> if the current controller is an Admin::BaseController
  def admin?
    controller.is_a?(Admin::BaseController)
  end
  
  def auto_link(text, *args, &block)
    text = text.to_s.gsub(/#([A-Za-z0-9\.\_\-]+)\b/) do |m|
      indicator, numeric_id = m[1..2].gsub(/[\.\d]/, ''), m[3..-1].gsub('.', '').to_i
      if klass = auto_link_pretty_map[indicator]
        opts = {:controller => klass.to_s.tableize, :action => :show, :id => numeric_id}
        link_to(m, opts, :class => 'pretty_id')
      else
        m
      end
    end
    super(text, *args, &block)
  end

  def available_locales
    [:de, :en]
  end

  # Renders a badge labelled with count, unless the given count is zero.
  def badge_for(count)
    count == 0 ? "" : ' ' << content_tag(:b, count, :class => 'badge')
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
  #
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
  #   contact_info(object, attr) # => String
  #
  # Returns a formatted string version of the attribute.
  # 
  # Examples:
  #   <%= contact_info(@company, :phone) %>
  #     # => '+49 (0) 234 366 98007'
  #
  #   <%= contact_info(@company, :website) %>
  #     # => '<a href="http://www.example.org/">www.example.org</a>'
  def contact_info(object, attr)
    if %w(phone fax).include?(attr)
      phone_number(object.__send__(attr))
    elsif %w(email website).include?(attr)
      auto_link(object.__send__(attr).to_s).html_safe
    else
      object.__send__(attr).to_s
    end
  end
  
  #:call-seq:
  #   controller?(name) # => boolean
  #
  # Returns <tt>true</tt> if c is the current controller.
  # Example:
  #   <%= controller?(:root) %>
  #     # => true
  def controller?(name)
    controller.controller_name == name.to_s
  end
  
  def float_tag(text = nil, dir = :left, &block)
    text = capture(&block) if block_given?
    content_tag :span, text, :class => "float_#{dir}"
  end
  
  # Returns a HTML formatted version of <tt>text</tt>.
  # 
  # Example:
  #   <%= format_multiline_input("First line.\nSecond Line.") %>
  #     # => "First line.<br>Second line."
  def format_multiline_input(text)
    simple_format(h(text)).html_safe
  end

  # Returns :freights if the user is currently looking at
  # freights and :loading_spaces if otherwise
  def freights_or_loading_spaces?
    arr = %w(freights loading_spaces)
    if arr.include?(controller_name)
      controller_name
    elsif arr.include?(action_name)
      action_name
    end
  end
  

  #:call-seq:
  #   highlight_in_search?(result) # => boolean
  #
  # Returns <tt>true</tt> if the given result should be highlighted, i.e.
  # if the company behind the posting has a certain number of positive reviews.
  def highlight_in_search?(result)
    return unless result.respond_to?(:company) && result.company
    result.company.approved_reviews.count > AppConfig['reviews.highlight_above'].to_i
  end
  
  # Returns a humanized string for the given ActionRecording.
  def humanize_recording(rec)
    opts = {
      :user => rec.user.full?(&:name),
      :object_class => rec.item.full?(&:class),
      :object_link => link_to_item(rec.item),
    }
    t("recordings.#{rec.action}", opts)
  end
  
  # Renders a linked button (optionally with an icon).
  def link_btn(text, path, opts = {}, html_opts = {})
    if icon = opts.delete(:icon)
      text = content_tag(:span, "", :class => 'icon') << text
    end
    text = content_tag(:span, text)
    opts[:class] = [
        :minibutton, 
        opts[:class].full? ? opts[:class] : icon.full?, 
        icon.full? { |i| "btn-#{i}" }
      ].compact.join(' ')
    link_to text, path, opts, html_opts
  end

  def link_btn_unless(condition, text, path, opts = {}, html_opts = {})
    if condition
      opts[:class] = "#{opts[:class]} minibutton-active".strip
    end
    link_btn(text, path, opts, html_opts)
  end

  def link_btn_unless_current(text, path, opts = {}, html_opts = {})
    link_btn_unless(current_page?(path), text, path, opts, html_opts)
  end

  # Renders a link to the given item.
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
  
  # Renders a link to the given result.
  def link_to_result(t, result)
    url_method = method(result.class.to_s.underscore << '_path')
    url = url_method.call(:id => result, :search_recording_id => @search_recording.full?(&:id))
    link_to(t, url)
  end
  
  # TODO: lookup rails3 implementation
  def link_to_unless(condition, name, options = {}, html_options = {}, &block) # :nodoc:
    condition ? content_tag(:span, name, html_options) : link_to(name, options, html_options, &block)
  end
  
  # Returns a formatted string for the associated LocalizedInfo object.
  def localized_info(obj, name, lang = I18n.locale)
    text = obj.localized_info(name, lang).text
    format_multiline_input(text) if text.full?
  end
  
  #  TODO: localized_info_field f, :type_of_goods, :en
  # BETTER: f.localized_info_field :type_of_goods, :en
  def localized_info_field(f, name, lang = current_person.locale) # :nodoc:
    render({:partial => '/partials/localized_info_form_content',
              :locals => {:f => f, :name => name, :lang => lang}})
  end
  
  def localized_info_fields(f, name, locales = [:de, :en])
    render({:partial => '/partials/localized_info_fields',
              :locals => {:f => f, :name => name, :locales => locales}})
  end
  
  def navi_to_unless(condition, text, opts = {}, html_opts = {})
    if condition
      html_opts[:class] = "#{html_opts[:class]} active".strip
      link_to(text, opts, html_opts)
    else
      link_to(text, opts, html_opts)
    end
  end
  
  def navi_to_unless_current(text, opts = {}, html_opts = {})
    navi_to_unless(current_page?(opts), text, opts, html_opts)
  end
  
  # REturns <tt>true</tt>, if only some attributes are not blank for the given ActiveRecord object.
  def only_some_attributes_filled?(ar)
    ar.attributes_filled < AppConfig['contact_info.complete_percentage'].to_f
  end
  
  # Tries to render a phone number in a certain format.
  # Returns the reformatted number.
  def phone_number(nr)
    country_code = AppConfig['contact_info.default_country_code'].to_s
    Phone.parse(nr, :country_code => country_code).format(:europe)
  rescue
    return nr
  end
  
  # Returns <tt>true</tt>, if the current_user is posting freights.
  def posting_freights?
    current_user.full?(&:posting_type) == 'Freight'
  end
  
  def postings_controller?
    %w(freights loading_spaces).include?(controller_name)
  end
  
  # Renders a partial with the contact information for the given company.
  # Example:
  #   <%= render_person_info current_company %>
  def render_company_info(company = resource.company)
    partial :sidebar_company_info, :locals => {:company => company}
  end
  
  # Renders a partial with the contact information for the given person.
  # Example:
  #   <%= render_person_info current_person %>
  def render_person_info(person)
    partial :sidebar_person_info, :locals => {:person => person}
  end
  
  # Renders a text next to a badge.
  def text_with_badge(snippet, count)
    (snippet.full? { t(snippet) }.to_s + badge_for(count)).html_safe
  end
  
  def yes_no(condition) # :nodoc:
    condition ? t("common.choice_yes") : t("common.choice_no")
  end
  
  def yes_no_collection
    [true, false].map { |b| [yes_no(b), b] }
  end
  
end
