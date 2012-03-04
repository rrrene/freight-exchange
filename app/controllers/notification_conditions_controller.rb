class NotificationConditionsController < RemoteController
  def index
    redirect_to :controller => "notification_condition_sets"
  end
  def show
    redirect_to :controller => "notification_condition_sets"
  end
end
