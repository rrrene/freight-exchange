class InheritedResources::Base
  class << self
    def api_enabled(opts = {})
      respond_to :html, :xml, :json, opts
    end
  end
end