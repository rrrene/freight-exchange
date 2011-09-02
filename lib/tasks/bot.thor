#!/usr/bin/env ruby -wKU

rails_dir = File.join(File.dirname(__FILE__), '..', '..')

require File.join(rails_dir, 'config', 'environment')

require File.join(rails_dir, 'script', 'robot')


class Bot < Thor
  desc "go", "run the bot"
  method_options %w(times -t) => 0
  method_options %w(actions -a) => []
  method_options %w(pause -p) => 2
  def go
    puts "options: " + options.inspect
    index = 0
    times = options[:times].to_i
    infinite = times == 0
    while infinite || (index < times)
      run_bot(options)
      sleep options[:pause].to_i
      index += 1
    end
  end
  
  private
  
  def run_bot(options)
    Robot::Bot.new.go(options)
  rescue SystemExit, Interrupt
    raise
  rescue Errno::ECONNREFUSED
    warn ' ' * 20 << "[X] No connection to server: #{Robot::SITE}"
  rescue Exception => e
    warn ' ' * 20 << '[i] rescued ' + e.class.to_s
    #raise
  end
end