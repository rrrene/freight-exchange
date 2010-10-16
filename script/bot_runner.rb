#!/usr/bin/env ruby -wKU

require File.join(File.dirname(__FILE__), 'robot')

loop do
  Robot::Bot.new.go
  sleep 2
end