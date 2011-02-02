# The Admin::BaseController is the controller every other backend controller inherits
# from. He is mainly responsible for providing basic functionality to all controllers
# in the Admin module, e.g. rights management.
class Admin::BaseController < ApplicationController
  inherit_resources
  role_required :administrator
  
  def index # :nodoc:
    @filter = params[:filter].full? || 'id'
    order_clause = "#{@filter} #{@filter == 'created_at' ? :DESC : :ASC}"
    instance_variable_set("@#{resource_class.to_s.pluralize.underscore}", resource_class.order(order_clause).all)
    index!
  end
end