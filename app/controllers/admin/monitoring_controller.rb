class Admin::MonitoringController < Admin::BaseController
  def index
    now = Time.new.midnight
    @creates = (1..30).to_a.reverse.map do |days_back|
      day = now - days_back.days
      arel = ActionRecording.where(:action => "create").where(["created_at >= ? AND created_at < ?", day, day+87600])
      hsh = {:day => day.strftime("%Y-%m-%d")}
      [User, Company, Freight, LoadingSpace].each do |model|
        hsh[model.to_s.underscore.pluralize.to_sym] = arel.where(:item_type => model).count
      end
      hsh
    end
  end
end
