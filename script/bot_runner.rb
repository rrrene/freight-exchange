#!/usr/bin/env ruby -wKU

require File.join(File.dirname(__FILE__), '..', 'config', 'environment')

class User < ActiveRecord::Base
  ROBOT_ARMY_SIZE = 30
  scope :robots, where('login LIKE "robot_%"')
end

require File.join(File.dirname(__FILE__), 'robot')

puts '', '', "=" * 70, '', ''

if User.robots.count < User::ROBOT_ARMY_SIZE
  create_robot_army!(User::ROBOT_ARMY_SIZE)
end

loop do
  begin
    Robot::Bot.new.go
    sleep 2
rescue REXML::ParseException => e
    nil
  end
end