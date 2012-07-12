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
    
    desc "postings", "ensure there are N postings (freights and loading_spaces) in the demo company"
    method_options %w(number -n) => 10
    def postings
      company = ::Demo::Company.instance
      existing = [company.freights, company.loading_spaces].inject(0) do |sum, model|
        sum += model.where(:deleted => false).where("parent_id is NULL").where('valid_until > ?', Time.now).count
      end
      how_many = options[:number].to_i - existing
      ::Demo::Company.create_postings(how_many) if how_many > 0
      stats
    end

    desc "monitoring", "ensure there are monitoring results for the past N days"
    method_options %w(number -n) => 31
    def monitoring
      how_many = options[:number].to_i
      models = GeneralObserver::OBSERVED_MODELS
      all = {}
      models.each { |model| all[model] = model.to_s.classify.constantize.all }
      (1..how_many).each do |days_back|
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
        puts "#{days_back}/#{how_many}"
      end
    end

    desc "stats", "shows the demo company's stats"
    def stats
      company = ::Demo::Company.instance
      logger.info "=== DEMO COMPANY =============================="
      logger.info "Name: ".ljust(20) + company.name
      %w(users loading_spaces freights).each do |assoc|
        logger.info "#{assoc.classify.pluralize}: ".ljust(20) + company.__send__(assoc).count.to_s
      end
      user = company.users.first
      count = user ? user.unread_notification_items.count : nil
      logger.info "Notifications/user: ".ljust(20) + count.to_s
    end
    
    private

    def logger
      @logger ||= App::Bot.logger
    end

  end
end