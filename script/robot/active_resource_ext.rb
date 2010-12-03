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
      def api_key=(api_key)
        self.user = api_key
      end
      
      def login(api_key = Robot::CurrentUser.api_key, &block)
        self.api_key = api_key
        yield if block_given?
      end
      alias login! login
    end
  end
end