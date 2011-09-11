#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), '..', 'config', 'environment')

require File.join(File.dirname(__FILE__), 'robot')

puts '', '', "=" * 70, '', ''

if User.robots.count < User::ROBOT_ARMY_SIZE
  create_robot_army!(User::ROBOT_ARMY_SIZE)
end

loop do
  begin
    ActiveResource::Base.site = 
    ActiveResource::Base.proxy = "http://localhost:3000/"
    Robot::Bot.new.go
    sleep 2
  rescue SystemExit, Interrupt
    raise
  rescue Exception => e
    warn ' ' * 20 << '[i] rescued ' + e.class.to_s
    raise
  end
end