#!/usr/bin/env ruby -wKU

module Robot
  class CurrentUser
    @@users = ::User.robots.all
    class << self
      attr_accessor :user
      def method_missing(m)
        random! if user.nil?
        user[m]
      end
      
      def random!
        self.user = @@users.random
      end
      
      def creates
        user.person.gender == 'female' ? :freight : :loading_space
      end
    end
  end
end