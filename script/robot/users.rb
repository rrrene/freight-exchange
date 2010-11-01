#!/usr/bin/env ruby -wKU

module Robot
  class CurrentUser
    @@users = ::User.robots.all
    class << self
      attr_accessor :user
      
      def id
        user.id
      end
      
      def method_missing(m)
        random! if user.nil?
        user[m]
      end
      
      def random!
        self.user = @@users.random
      end
      
      def creates
        user.posting_type.underscore
      end
    end
  end
end