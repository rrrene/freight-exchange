class StationsController < RemoteController

  def autocomplete
    q = params[:query]
    order_by = q =~ /^\d+$/ ? :numeric_id : :name
    @stations = Station.where("numeric_id LIKE ? OR name like ?", "#{q}%", "#{q}%").limit(20).order(order_by)
    @dom_element_id = params[:dom_element_id]
    @field_name = params[:field_name]
  end

end
