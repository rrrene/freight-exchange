#!/usr/bin/env ruby -wKU

require 'pp'
require File.join(File.dirname(__FILE__), '..', 'config', 'environment')

models = GeneralObserver::OBSERVED_MODELS
all = {}
models.each { |model| all[model] = model.to_s.classify.constantize.all }

puts '', '', "=" * 70, '', ''

(1..183).each do |days_back|
  recordings_for_this_day = (25 + rand * 100).to_i
  recordings_for_this_day.times do
    action = %w(create create create update destroy read read read).rand
    model = models.rand
    user = all[:user].rand
    item = all[model].rand
    if item.full?
      opts = {:action => action,
        :item_type => model.to_s.classify, :item_id => item.id,
        :user_id => user.id, :company_id => user.company.id,
        :created_at => Time.new - days_back * 87600 + rand * 87600
      }
      ActionRecording.create(opts)
    end
  end
  puts days_back
end