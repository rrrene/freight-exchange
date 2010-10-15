#!/usr/bin/env ruby -wKU

require 'rubygems'
require 'active_resource'

class Array
  def random
    sort_by { rand * 2 - 1 }.first
  end
end

module Robot
  SITE = "http://localhost:3000/"
end

require File.join(File.dirname(__FILE__), 'robot', 'users')
require File.join(File.dirname(__FILE__), 'robot', 'places')
require File.join(File.dirname(__FILE__), 'robot', 'freight')
require File.join(File.dirname(__FILE__), 'robot', 'active_resource_ext')

module Robot
  module Actions
    def create_freight
      Robot::Freight.create
    end
    
    def create_loading_space
    end
    
    def create_memo
    end
    
    def approve_memo
    end
  end
  
  class Bot
    def initialize
      CurrentUser.random!
    end
    
    def go
      puts "create_#{CurrentUser.creates}"
      print Time.new.strftime("%Y-%m-%d %H:%M:%S") + "  "
      print CurrentUser.login.to_s.ljust(30)
      print actions.random
      print "\n"
    end
    
    def actions
      %w(create_freight create_loading_space delete_something 
        approve_memo create_memo
          ) - ["create_#{CurrentUser.creates}"]
    end
    
    private
    include Robot::Actions
  end
end

loop do
  Robot::Bot.new.go
  sleep 2
end