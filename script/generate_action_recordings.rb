#!/usr/bin/env ruby -wKU

require 'pp'
require File.join(File.dirname(__FILE__), '..', 'config', 'environment')

models = GeneralObserver::OBSERVED_MODELS
all = {}
models.each { |model| all[model] = model.to_s.classify.constantize.all }

puts '', '', "=" * 70, '', ''

(1..7).each do |days_back|
  actions_for_this_day = (75 + rand * 50).to_i
  actions_for_this_day.times do
    action = %w(create update destroy).rand
    model = models.rand
    user = all[:user].rand
    opts = {:action => action, 
        :item_type => model.to_s.classify, :item_id => all[model].rand.id,
        :user_id => user.id, :company_id => user.company.id,
        :created_at => Time.new - days_back * 87600 + rand * 87600
      }
    pp ActionRecording.create(opts)
  end
end