class NotificationBuilder
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
        if klass.new(user, object).add_object_to_users_notification?
          self.notification << object
        end
      end
      notification.close!
      puts "| #{user.id.to_s.ljust(5)} | #{timestamp.to_s.ljust(25)} | #{notification.notification_items.count.to_s.rjust(10)} |"
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
          ::Freight.where(:deleted => false).where("parent_id is NULL"),
          ::LoadingSpace.where(:deleted => false).where("parent_id is NULL"),
          ::Review.where('approved_by_id IS NULL')
        ].map do |model|
          model.where('company_id != ? AND updated_at > ?', company.id, timestamp).all
        end.flatten
      end
    end
  end
end
