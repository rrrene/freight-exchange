# Recorder
module Recorder
  class Recording < ActiveRecord::Base
    serialize :diff
    belongs_to :item, :polymorphic => true
  end
  
  # This class can be used to observe any given Model and track all the changes
  # made.
  # 
  #   class UserObserver < Recorder::Observer
  #     ignore :updated_at, :created_at, :password, :password_confirmation
  #   end
  class Observer < ActiveRecord::Observer
    @@ignored_attributes = {}
    @@recording_classes = {}

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

      # Specifies an attribute that is always saved when changes are made.
      #   ProductObserver.always_save(:price, Proc.new { |item| item.price })
      #   ProductObserver.always_save(:price) { |item| item.price }
      #   ProductObserver.always_save(:price, &:price)
      # 
      # Or use it to share information between your controller and your model:
      #   UberObserver.always_save(:user_id, current_user.id)
      #   UberObserver.always_save(:admin_change, current_user.is_admin?)
      #
      # NOTE: You have to add the column for storing _attribute_ yourself using migrations!
      def always_save(attribute, value_or_proc = nil, &block)
        additional_attributes[attribute] = block_given? ? block : value_or_proc
      end

      # Specifies attributes that are not included in the _diff_ column.
      # 
      #   class SomeObserver < Recorder::Observer
      #     ignore :updated_at, :created_at
      #   end
      def ignore_attributes(*attributes)
        @@ignored_attributes[name] = attributes.flatten.map(&:to_s)
      end
      alias ignore ignore_attributes
      
      # Specifies the class_name of the generated recordings, defaults to 'Recording'.
      #   class EmployeeObserver <  Recorder::Observer
      #     recording_class 'PersonnelRecord'
      #   end
      def recording_class(class_name = 'Recording')
        @@recording_classes[name] = class_name.constantize
      end
    end

    private
    
    def additional_attributes_for(ar)
      attributes = self.class.additional_attributes.dup
      attributes.each { |key, value_or_proc| 
        attributes[key] = value_or_proc.call(ar) if value_or_proc.is_a?(Proc)
      }
      attributes
    end
    
    def create_recording(ar, action)
      diff = ar.changes.delete_if { |k, v| 
        @@ignored_attributes[self.class.name].include?(k.to_s) 
      }
      unless diff.empty?
        opts = {
            :action => action.to_s, :diff => diff, :item => ar
          }.merge(additional_attributes_for(ar))
        recording_class.create(opts)
      end
    end

    def recording_class
      @@recording_classes[self.class.name] || Recording
    end
  end
  
end