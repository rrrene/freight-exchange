class UserNotifier < ActionMailer::Base
  default :from => "noreply@#{AppConfig[:domain]}"
  
  def forgot_password(user, password)
    @user = user
    @password = password
    default_url_options[:host] = AppConfig[:domain]
    mail(:subject => t("user_notifier.forgot_password.subject"), :to => @user.email)
  end
  
  def notification(user, notification)
    @user, @notification = user, notification
    default_url_options[:host] = AppConfig[:domain]
    mail(:subject => t("user_notifier.notification.subject"), :to => @user.email)
  end
end
