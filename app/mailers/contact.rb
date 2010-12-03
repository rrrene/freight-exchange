class Contact < ActionMailer::Base
  default :from => "from@example.com"
  default :to => "rf-da@bamaru.de"
  
  def contact(text, user)
    @text = text
    @user = user
    @person, @company, = @user.person, @user.company
    mail(:subject => "Contact Form")
  end
end
