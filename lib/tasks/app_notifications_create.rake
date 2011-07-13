class NotificationBuilder
  class Base
    attr_accessor :user, :object
    def initialize(_user, _object)
      self.user, self.object = _user, _object
    end
    def add_to_notification?
      false
    end
  end

  class Freight < Base
    MATCHING_MINIMUM = 0.1

    def add_to_notification?
      chain = MatchingRecording.scoped
      chain = chain.where(:b_type => 'LoadingSpace', :b_id => user.company.loading_space_ids)
      chain = chain.where(:a_type => 'Freight', :a_id => object.id)
      chain = chain.where('result >= ?', MATCHING_MINIMUM)
      chain.count > 0
    end
  end

  class LoadingSpace < Base
    MATCHING_MINIMUM = 0.1

    def add_to_notification?
      chain = MatchingRecording.scoped
      chain = chain.where(:a_type => 'LoadingSpace', :a_id => user.company.loading_space_ids)
      chain = chain.where(:b_type => 'Freight', :b_id => object.id)
      chain = chain.where('result >= ?', MATCHING_MINIMUM)
      chain.count > 0
    end
  end

  class Review < Base
    def add_to_notification?
      object.approved_by_id.blank?
    end
  end

  class Factory
    attr_accessor :user, :notification, :timestamp

    def initialize(_user)
      self.user = _user
      self.notification = user.current_notification
      self.timestamp = user.last_notification.closed_at.full? || 1.week.ago
    end

    def build!
      created_objects.each do |object|
        klass = case object
          when ::Freight
            Freight
          when ::LoadingSpace
            LoadingSpace
          when ::Review
            Review
          else
            raise "unknown object type: #{object.class}"
        end
        if klass.new(user, object).add_to_notification?
          self.notification << object
        end
      end
      notification.close!
      #puts "| #{user.id.to_s.ljust(5)} | #{timestamp.to_s.ljust(25)} | #{notification.notification_items.count.to_s.rjust(10)} |"
    end

    private

    def matching_recordings_greater_than(posting, result)
      arel = MatchingRecording.where('updated_at > ?', timestamp)
      if posting.is_a?(Freight)
        arel = arel.where(:a_type => posting.class.to_s, :a_id => posting.id)
      else
        arel = arel.where(:b_type => posting.class.to_s, :b_id => posting.id)
      end
      arel.where('result >= ?', result)
    end

    def created_objects
      @created_objects ||= begin
        company = user.company
        [
          ::Freight.where(:deleted => false),
          ::LoadingSpace.where(:deleted => false),
          ::Review.where('approved_by_id IS NULL')
        ].map do |model|
          model.where('company_id != ? AND updated_at > ?', company.id, timestamp).all
        end.flatten
      end
    end
  end
end

namespace :app do
  namespace :notifications do
    desc "Generate notifications for the users."
    task :create => :environment do
      puts "+-#{'-'.*(5)}-+-#{'-'.*(25)}-+-#{'-'.*(10)}-+"
      puts "| #{'User'.ljust(5)} | #{'Timestamp'.ljust(25)} | #{'Items'.ljust(10)} |"
      puts "+-#{'-'.*(5)}-+-#{'-'.*(25)}-+-#{'-'.*(10)}-+"
      User.all.each do |current_user|
        NotificationBuilder::Factory.new(current_user).build!
      end
      puts "+-#{'-'.*(5)}-+-#{'-'.*(25)}-+-#{'-'.*(10)}-+"
    end
  end
end