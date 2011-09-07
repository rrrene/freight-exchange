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
      if item_type = params[:item_type].presence
        @notification_items = @notification_items.where(:item_type => item_type)
      end
      @notifications = @notification_items.map(&:notification)
      @notification = @notifications.first
    end
    @notification_items = @notification_items.paginate(:page => params[:page], :per_page => RemoteController::PER_PAGE)
    @unread = current_user.unread_notification_items.all
  end
end
