class NotificationConditionSetsController < RemoteController

  def create
    @notification_condition_set = NotificationConditionSet.new(params[:notification_condition_set])
    @notification_condition_set.company = current_company
    @notification_condition_set.user = current_user
    if @notification_condition_set.save
      respond_to do |format|
        format.html { redirect_to :action => "index" }
      end
    end
  end

  def order_map
    {
      :default => :created_at,
      :id => 'id ASC',
      :created_at => 'created_at DESC',
    }
  end

end
