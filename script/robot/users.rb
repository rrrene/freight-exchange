#!/usr/bin/env ruby -wKU

module Robot
  class CurrentUser
    class << self
      attr_accessor :user
      
      def id
        random! if !user
        user.id
      end
      
      def method_missing(m)
        random! if user.nil?
        user[m]
      end
      
      def random!
        self.user = ::User.robots.all.random
      end
      
      def creates
        user.posting_type.underscore
      end
    end
  end
end