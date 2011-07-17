module NotificationsHelper
  
  def relevant_notification_items_count
    @relevant_notification_items_count ||= @unread ? @unread.count : current_user.unread_notification_items.count
  end
end
