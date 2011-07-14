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
    if params[:id]
      @notification = current_user.notifications.find(params[:id])
      @notifications = [@notification]
      @notification_items = @notification.notification_items
    else
      @notification_items = current_user.notification_items.includes(:notification)
      @notifications = @notification_items.map(&:notification)
      @notification = @notifications.first
    end
    @unread = []
    @notifications.each do |notification|
      unless notification.viewed?
        @unread.concat notification.notification_items
        #notification.viewed!
      end
    end
  end
end
