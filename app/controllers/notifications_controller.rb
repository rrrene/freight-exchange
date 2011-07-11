class NotificationsController < ApplicationController
  def index
    @notification = current_user.last_notification
    render :action => :show
  end
  
  def show
    @notification = current_user.notifications.find(params[:id])
    @notification_items = @notification.notification_items
  end
end
