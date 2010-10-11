module Admin::BaseHelper
  def controller_catalog
    controller.controller_path.gsub('/', '.')
  end
  
  def link_new
    link_to t("admin.common.new_link"), new_resource_url, :class => 'new'
  end
  
  # Renders a table for the given ActiveRelation.
  # Example:
  #   <%= render_table User.all %>
  def render_table(arel)
    return if arel.first.nil?
    render_partial :table, :locals => {:model => arel.first.class, :arel => arel}
  end
  
end
