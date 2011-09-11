#!/usr/bin/env ruby -wKU

module Robot
  class Bot
    def go(options = {})
      report { 
        @action = (options[:actions].presence || actions).random
        perform_action 
      }
    end
    
    def perform_action
      perform_action_by_active_resource
    end
    
    def perform_action_by_active_resource
      CurrentUser.random!
      ActiveResource::Base.login! {
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
