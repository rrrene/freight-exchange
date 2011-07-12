class NotificationsController < ApplicationController
  login_required
  
  def index
    set_notification
    render :action => :show
  end
  
  def show
    set_notification
  end
  
  def set_notification
    @notification = if params[:id]
      current_user.notifications.find(params[:id])
    else
      current_user.last_notification
    end
    @notification.viewed!
    @notification_items = @notification.notification_items
  end
end
