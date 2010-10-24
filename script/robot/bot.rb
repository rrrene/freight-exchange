#!/usr/bin/env ruby -wKU

module Robot
  class Bot
    def initialize
      CurrentUser.random!
    end
    
    def go
      report { perform_action }
    end
    
    def perform_action
      @action = (actions_from_argv || actions).random
      method(@action).call
    end
    
    def report(&block)
      yield
      puts [Time.new.strftime("%Y-%m-%d %H:%M:%S"), 
              CurrentUser.login.to_s.ljust(30), @action].join(' ')
    end
    
    def actions_from_argv
      ARGV unless ARGV.empty?
    end
    
    def actions
      %w(create_user edit_user delete_user
        approve_review create_review
          ) + ["create_#{CurrentUser.creates}", "delete_#{CurrentUser.creates}"]
    end
    
    private
    include Robot::Actions
  end
end
