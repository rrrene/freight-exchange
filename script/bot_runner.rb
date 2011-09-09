#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), '..', 'config', 'environment')

require File.join(File.dirname(__FILE__), 'robot')

puts '', '', "=" * 70, '', ''

if Robot::User.count < Robot::User::ROBOT_ARMY_SIZE
  Robot::User.create_robot_army!
end

loop do
  begin
    Robot::Bot.new.go
    sleep 2
  rescue SystemExit, Interrupt
    raise
  rescue Exception => e
    warn ' ' * 20 << '[i] rescued ' + e.class.to_s
    #raise
  end
end