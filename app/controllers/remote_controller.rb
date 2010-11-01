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
  
  def show
    show! {
      page[:title] = t("#{controller_catalog}.show.page_title", {:name => resource.name})
    }
  end
end
