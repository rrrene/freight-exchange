#!/usr/bin/env ruby -wKU

require 'rubygems'
require 'active_resource'

module Robot
  SITE = "http://localhost:3000/"
end

%w(array_ext users places freight actions active_resource_ext).each do |rb|
  require File.join(File.dirname(__FILE__), 'robot', rb)
end

module Robot
  class Bot
    def initialize
      CurrentUser.random!
    end
    
    def go
      puts actions
      print Time.new.strftime("%Y-%m-%d %H:%M:%S") + "  "
      print CurrentUser.login.to_s.ljust(30)
      print actions.random
      print "\n"
    end
    
    def actions
      %w(create_user edit_user delete_user
        approve_memo create_memo
          ) + ["create_#{CurrentUser.creates}", "delete_#{CurrentUser.creates}"]
    end
    
    private
    include Robot::Actions
  end
end

loop do
  Robot::Bot.new.go
  sleep 2
end