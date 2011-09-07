#!/usr/bin/env ruby -wKU

rails_dir = File.join(File.dirname(__FILE__), '..', '..')

require File.join(rails_dir, 'config', 'environment')

require File.join(rails_dir, 'script', 'robot')

module App
  class Demo < Thor
    
    desc "reset", "reset the demo company"
    def reset
      ::Demo::Company.instance_eval do
        instance.destroy
        setup
      end
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
    end
  end
end