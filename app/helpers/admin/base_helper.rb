# The BaseHelper provides basic helper methods all backend views.
module Admin::BaseHelper

  def contextual_admin_search_controller
    if action_name != 'dashboard'
      if %w(companies freights loading_spaces stations).include?(controller_name)
        return controller_name
      end
    end
    'search'
  end

  def chart_for_records(record_class, opts = {})
    steps = opts.delete(:steps) || 7
    step_width = opts.delete(:step_width) || 1.day
    attribute = opts.delete(:attribute) || :created_at
    data = []
    labels = []
    time = Time.new.midnight
    (0..steps).to_a.reverse.each do |index|
      from_time = time - index * step_width
      to_time = from_time+ step_width
      count = record_class.where(["#{attribute} > ? AND #{attribute} < ?", from_time, to_time]).count
      labels << Time.at(from_time.to_i).strftime("%d.")
      data << count
    end
    std_opts = {
        :type => :bar, :data => data, :labels => labels, 
        :colors =>"A2C180,3D7930", 
        :marker_format => "N*f0*,000000,0,-1,#{data.size}",
        :size => "220x120"
      }
    google_chart_tag std_opts.merge(opts)
  end
  
  def pie_chart_for_records(record_class, opts = {})
    attribute = opts.delete(:attribute) || :created_at
    data = []
    labels = []
    record_class.group(attribute).each do |record|
      value = record.__send__(attribute)
      count = record_class.where(attribute => value).count
      data << count
      labels << "#{value} (#{count})"
    end
    std_opts = {
        :type => :pie, :data => data, :labels => labels, 
        :size => "280x120"
      }
    google_chart_tag std_opts.merge(opts)
    
  end
  
  def google_chart_tag(options = {})
    options[:size] ||= "220x100"
    options[:type] ||= "line"
    image_tag google_chart_url(options), :size => options[:size], :title => google_chart_url(options)
  end
  
  def google_chart_url(options = {}, base_url = "http://chart.apis.google.com/chart?")
    gchart_check_max_size(options[:size])
    [:data, :colors, :labels].each do |field|
      if options[field].is_a?(Array)
        options[field] = options[field].collect(&:to_s) * (field == :labels ? '|' : ',')
      end
    end
    options[:data] = "t:#{options[:data]}" unless options[:data].to_s.match(/^[tse]\:/)
    arr = []
    options.each { |k, v| arr << "#{gchart_translate(k)}=#{gchart_translate(v)}" }
    base_url + arr * '&'
  end
  
  def gchart_check_max_size(size, maximum_pixels = 300_000)
    pixels = size.split('x').inject(1) { |a,b| a.to_i * b.to_i }
    if pixels > maximum_pixels
      raise "Too many pixels in google chart: #{pixels} > #{maximum_pixels} max" 
    end
  end
  
  def gchart_translate(field)
    general = {:size => :chs, :type => :cht, :data => :chd, :labels => :chl, :title => :chtt, :colors => :chco, :marker_format => :chm}
    types = {:line => :lc, :spark => :ls, :pie => :p, :pie3d => :p3, :bar => :bvs}
    general.merge(types)[field.to_s.intern].full? || field
  end
  
  
  # Renders a link to the new action of the current resource.
  def link_new(text = t("admin.common.new_link"), url = new_resource_url)
    link_to text, url, :class => 'new'
  end
  
  # Renders a table for a given ActiveRelation.
  # 
  # Example:
  #   <%= render_table User.all %>
  def render_table(arel)
    return if arel.first.nil?
    partial :table, :locals => {:model => arel.first.class, :arel => arel}
  end
  
end
