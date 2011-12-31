class UserNotifier < ActionMailer::Base
  default :from => "from@example.com"
  
  def forgot_password(user, password)
    @user = user
    @password = password
    default_url_options[:host] = AppConfig[:domain]
    mail(:subject => t("user_notifier.forgot_password.subject"), :to => @user.email)
  end
end
