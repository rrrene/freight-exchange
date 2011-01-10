#!/usr/bin/env ruby -wKU

require 'pp'
require File.join(File.dirname(__FILE__), '..', 'config', 'environment')
require File.join(File.dirname(__FILE__), 'robot')

users = User.all

puts '', '', "=" * 70, '', ''

include Robot::Actions

(1..7).each do |days_back|
  recordings_for_this_day = (75 + rand * 50).to_i
  recordings_for_this_day.times do
    user = users.rand
    opts = {
        :query => generate_search_query,
        :user_id => user.id,
        :results => rand(100),
        :created_at => Time.new - days_back * 87600 + rand * 87600
      }
    puts 
    pp SearchRecording.create(opts)
  end
end