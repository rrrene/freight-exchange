class RemoteController < ApplicationController
  class << self
    # Use this in a controller to allow access to  
    # certain actions (defaults to all actions) via xml and json.
    #
    #   class StationsController < InheritedResources::Base
    #     remote_enabled :only => :show
    #   end
    #
    # To restrict API access to actual users, simply use 
    # <tt>login_required</tt>. This way, requests have to provide an API key 
    # in the params.
    # Of course you can also use <tt>role_required</tt> and the like
    # for finer access management.
    #
    #   class PeopleController < InheritedResources::Base
    #     remote_enabled
    #     login_required
    #     role_or_ownership_required :company_admin, :only => [:edit, :update]
    #   end
    #
    #
    def remote_enabled(opts = {})
      respond_to :html, :xml, :json, opts
    end
  end
  
  inherit_resources
  remote_enabled
  login_required

  helper_method :default_order_param

  def index(&block)
    self.collection = resource_class.scoped
    filter_collection!
    perform_search!
    order_collection!
    index!(&block)
  end

  # The standard show action. 
  # 
  # Sets a default page title. 
  def show
    show! {
      page[:title] = t("#{controller_catalog}.show.page_title", {:name => resource.name})
    }
  end

  private

  def collection=(val)
    instance_variable_set("@#{collection_name}", val)
  end

  def collection_name
    instance_name.pluralize
  end

  def instance_name
    controller_name.classify.underscore
  end
  alias resource_key instance_name

  def resource=(val)
    instance_variable_set("@#{instance_name}", val)
  end

  def perform_search!
    if @q = params[:q].full?
      @simple_searches = SimpleSearch.arel_for(@q, :models => [resource_class])
      @resource_ids = @simple_searches.map(&:item_id)
      self.collection = collection.where(:id => @resource_ids)
    end
  end

  def filter_collection!
  end

  def order_collection!
    order = order_map[params[:order].full?(&:to_sym) || default_order_param]
    self.collection = collection.order(order)
  end

  def order_map
    {
      :default => :name,
      :id => 'id ASC',
      :login => 'UPPER(login) ASC',
      :name => 'UPPER(name) ASC',
      :created_at => 'created_at DESC',
    }
  end

  def default_order_param
    order_map[:default]
  end
end
