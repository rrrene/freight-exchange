class Recorder < ActiveRecord::Observer
  @@not_recorded = %w(last_request_at perishable_token updated_at created_at)
  observe :user, :app_config

  def after_create(ar)
    create_record(ar, :create)
  end

  def after_update(ar)
    puts "[recorder] update #{ar}"
    puts self.class.additional_attributes.inspect
    create_record(ar, :update)
  end

  def before_destroy(ar)
    create_record(ar, :destroy)
  end
  
  class << self
    def additional_attributes
      Thread.current[:recorder_attributes] ||= {}
    end
    
    def always_save(key, value)
      additional_attributes[key] = value
      puts "always_save: #{additional_attributes.inspect}"
    end
  end
  
  private

  def create_record(ar, action)
    diff = ar.changes.delete_if { |k, v| @@not_recorded.include?(k) }
    unless diff.empty?
      opts = {:action => action.to_s, :diff => diff, :item => ar}
      Recording.create(opts.merge(self.class.additional_attributes))
    end
  end
  
end
