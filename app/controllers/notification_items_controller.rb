class NotificationItemsController < ApplicationController
  login_required
  
  def mark_all_as_read
    current_user.unread_notification_items.each(&:viewed!)
    redirect_to :controller => 'notifications', :action => 'index'
  end
  
  def show
    @notification_item = NotificationItem.find(params[:id])
    @notification_item.viewed!
    redirect_to @notification_item.item
  end
end
