#!/usr/bin/env ruby -wKU

module Robot
  class CurrentUser
    @@users = [
      {
        :login => :freight_supplier,
        :api_key => "55024db979499d5568f0859d046da09f47234a74",
        :creates => :freight
      },
      {
        :login => :loading_space_supplier,
        :api_key => "69c6d0012c7cfacd805de990288f24f22c5c0431",
        :creates => :loading_space
      },
    ]
    class << self
      attr_accessor :user
      def method_missing(m)
        random! if user.nil?
        user[m]
      end
      
      def random!
        self.user = @@users.random
      end
    end
  end
end