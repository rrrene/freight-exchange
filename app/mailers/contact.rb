class Contact < ActionMailer::Base
  default :from => "from@example.com"
  
  def contact(text, user)
    @text = text
    @user = user
    @person, @company, = @user.person, @user.company
    mail(:subject => "Contact Form", :to => AppConfig[:support_email])
  end
end
