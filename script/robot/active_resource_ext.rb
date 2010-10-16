#!/usr/bin/env ruby -wKU


module ActiveResource
  class Base
    self.site = Robot::SITE
    self.proxy = Robot::SITE
    self.timeout = 2000
    
    def api_key=(api_key)
      connection.user = api_key
    end
    
    class << self
      alias old_create create
      def create
        f = self.new(Factory.attributes_for(to_s))
        f.api_key = Robot::CurrentUser.api_key
        f.save
        f
      end
    end
  end
end