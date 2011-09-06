class NotificationItemsController < ApplicationController
  login_required
  
  def show
    @notification_item = NotificationItem.find(params[:id])
    @notification_item.viewed!
    redirect_to @notification_item.item
  end
end
