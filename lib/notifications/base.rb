class NotificationBuilder
  class Base
    attr_accessor :user, :object
    def initialize(_user, _object)
      self.user, self.object = _user, _object
    end
    def add_object_to_users_notification?
      false
    end
  end

  class Freight < Base
    MATCHING_MINIMUM = 0.1

    def add_object_to_users_notification?
      chain = MatchingRecording.scoped
      chain = chain.where(:b_type => 'LoadingSpace', :b_id => user.company.loading_space_ids)
      chain = chain.where(:a_type => 'Freight', :a_id => object.id)
      chain = chain.where('result >= ?', MATCHING_MINIMUM)
      chain.count > 0
    end
  end

  class LoadingSpace < Base
    MATCHING_MINIMUM = 0.1

    def add_object_to_users_notification?
      chain = MatchingRecording.scoped
      chain = chain.where(:a_type => 'LoadingSpace', :a_id => user.company.loading_space_ids)
      chain = chain.where(:b_type => 'Freight', :b_id => object.id)
      chain = chain.where('result >= ?', MATCHING_MINIMUM)
      chain.count > 0
    end
  end

  class Review < Base
    def add_object_to_users_notification?
      object.approved_by_id.blank?
    end
  end
end