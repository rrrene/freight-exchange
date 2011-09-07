#!/usr/bin/env ruby -wKU

rails_dir = File.join(File.dirname(__FILE__), '..', '..')

require File.join(rails_dir, 'config', 'environment')

require File.join(rails_dir, 'script', 'robot')

module App
  class Demo < Thor
    
    desc "reset", "reset the demo company"
    method_options %w(postings -p) => 10
    method_options %w(notifications -n) => 5
    def reset
      ::Demo::Company.instance.destroy
      ::Demo::Company.setup(options) if options[:postings]
      ::Demo::Company.fake_notifications(options[:notifications]) if options[:notifications]
      stats
    end
    
    desc "notifications", "create notifications for the users of the demo company"
    method_options %w(number -n) => 10
    def notifications
      ::Demo::Company.fake_notifications(options[:number])
      stats
    end
    
    desc "postings", "create postings for the demo company"
    method_options %w(number -n) => 10
    def postings
      ::Demo::Company.create_postings(options[:number])
      stats
    end
    
    desc "stats", "shows the demo company's stats"
    def stats
      company = ::Demo::Company.instance
      puts "=== DEMO COMPANY =============================="
      puts "Name: ".ljust(20) + company.name
      %w(users loading_spaces freights).each do |assoc|
        puts "#{assoc.classify.pluralize}: ".ljust(20) + company.__send__(assoc).count.to_s
      end
      puts "Notifications/user: ".ljust(20) + company.users.first.unread_notification_items.count.to_s
    end
  end
end