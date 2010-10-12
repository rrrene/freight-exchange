class InheritedResources::Base
  class << self
    # Use this in a controller to allow access to  
    # certain actions (defaults to all actions) via xml and json.
    #
    #   class StationsController < InheritedResources::Base
    #     api_enabled :only => :show
    #   end
    #
    # To restrict API access to actual users, simply use login_required. 
    # This way, requests have to provide an API key in the params.
    #
    #   class PeopleController < InheritedResources::Base
    #     login_required
    #     api_enabled
    #   end
    #
    #
    def api_enabled(opts = {})
      respond_to :html, :xml, :json, opts
    end
  end
end