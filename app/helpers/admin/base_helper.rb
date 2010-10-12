# The BaseHelper provides basic helper methods all backend views.
module Admin::BaseHelper
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
    render_partial :table, :locals => {:model => arel.first.class, :arel => arel}
  end
  
end
