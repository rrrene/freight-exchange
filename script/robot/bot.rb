#!/usr/bin/env ruby -wKU

require 'term/ansicolor'

class ::String
  include Term::ANSIColor
end

module Robot
  class Bot
    def go
      report { perform_action }
    end
    
    def perform_action
      CurrentUser.random!
      ActiveResource::Base.login! {
        @action = (actions_from_argv || actions).random
        method(@action).call
      }
    end
    
    def report(&block)
      ret = yield
      str = @action.dup.ljust(20)
      str = str.green if @action =~ /create_/
      str = str.red if @action =~ /delete_/
      str = str.yellow if @action =~ /(approve|edit)_/
      str = str.magenta if @action =~ /(search)/
      puts [Time.new.strftime("%Y-%m-%d %H:%M:%S").ljust(20), 
            CurrentUser.login.to_s.ljust(25),
            str,
            ret.is_a?(String) ? ret : nil
          ].compact.join
    end
    
    def actions_from_argv
      ARGV unless ARGV.empty?
    end
    
    def actions
      with_priority %w(create_posting create_review create_user delete_posting edit_user delete_user approve_review)
    end
    
    def with_priority(all_actions)
      all_actions.map { |action|
        arr = [action]
        if action =~ /create/
          arr * 3
        elsif action =~ /(delete|approve)/
          arr * 2
        else
          arr
        end
      }.flatten
    end
    
    private
    include Robot::Actions
  end
end
