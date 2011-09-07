#!/usr/bin/env ruby -wKU

rails_dir = File.join(File.dirname(__FILE__), '..', '..')

require File.join(rails_dir, 'config', 'environment')

require File.join(rails_dir, 'script', 'robot')


class Bot < Thor
  DEFAULT_SITE = "http://localhost:3000/"
  
  desc "go", "run the bot"
  method_options %w(number -n) => 0
  method_options %w(actions -a) => []
  method_options %w(pause -p) => 2
  method_options %w(site -s) => DEFAULT_SITE
  def go
    index = 0
    times = options[:number].to_i
    infinite = times == 0
    while infinite || (index < times)
      run_bot(options)
      sleep options[:pause].to_i
      index += 1
    end
  end
  
  desc "postings", "ensures a given number of existing, valid postings (defaults to 50)"
  method_options %w(number -n) => 50
  method_options %w(actions -a) => %w(create_posting)
  method_options %w(site -s) => DEFAULT_SITE
  def refill
    existing = [Freight, LoadingSpace].inject(0) do |sum, model|
      sum += model.where(:deleted => false).where('valid_until > ?', Time.now).count
    end
    (existing...options[:number].to_i).to_a.each do |i|
      run_bot options
    end
  end
  
  private
  
  def run_bot(options)
    ActiveResource::Base.site = 
    ActiveResource::Base.proxy = options[:site]
    Robot::Bot.new.go(options)
  rescue SystemExit, Interrupt
    raise
  rescue Errno::ECONNREFUSED
    warn ' ' * 20 << "[X] No connection to server: #{ActiveResource::Base.site}"
  rescue Exception => e
    warn ' ' * 20 << '[i] rescued ' + e.class.to_s
    raise
  end
end