# Recorder
module Recorder
  class Recording < ActiveRecord::Base
    serialize :diff
    belongs_to :item, :polymorphic => true
  end
  
  class Observer < ActiveRecord::Observer
    @@ignored_attributes = {}

    def after_create(ar) # :nodoc:
      create_recording(ar, :create)
    end

    def after_update(ar) # :nodoc:
      create_recording(ar, :update)
    end

    def before_destroy(ar) # :nodoc:
      create_recording(ar, :destroy)
    end

    class << self
      def additional_attributes # :nodoc:
        Thread.current[:recorder_attributes] ||= {}
      end

      # Specify an attribute that is always saved along with the standard columns
      # e.g. always_save(:user_id, current_user.id)
      def always_save(key, value)
        additional_attributes[key] = value
      end

      # Specify attributes that are not included in the 'diff'
      def ignore_attributes(*attributes)
        @@ignored_attributes[name] = attributes.flatten.map(&:to_s)
      end
    end

    private

    def create_recording(ar, action)
      diff = ar.changes.delete_if { |k, v| 
        @@ignored_attributes[self.class.name].include?(k.to_s) 
      }
      unless diff.empty?
        opts = {:action => action.to_s, :diff => diff, :item => ar}
        Recording.create(opts.merge(self.class.additional_attributes))
      end
    end
  end
end