class NotificationBuilder
  class Base
    attr_accessor :user, :object

    def initialize(_user, _object)
      self.user, self.object = _user, _object
    end

    def add_object_to_users_notification?
      meets_users_conditions?
    end

    def meets_users_conditions?
      type = self.class.to_s.split('::').last
      sets = user.notification_condition_sets.where(:resource_type => type)
      !!sets.detect { |set| meets_condition_set?(set) }
    end

    def meets_condition_set?(set)
      conditions = set.notification_conditions
      conditions.full? && conditions.all? { |c| meets_condition?(c) }
    end

    def meets_condition?(condition)
      if object.respond_to?(condition.attribute_name)
        value = object.send(condition.attribute_name)
        if condition.qualifier == "equal"
          value == condition.value
        else
          raise "Unknown qualifier: #{condition.qualifier}"
        end
      end
    end
  end

  class Freight < Base
  end

  class LoadingSpace < Base
  end

  class Review < Base
    def add_object_to_users_notification?
      object.approved_by_id.blank?
    end
  end
end