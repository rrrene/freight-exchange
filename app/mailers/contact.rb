class Contact < ActionMailer::Base
  default :from => "from@example.com"
  
  # Returns a contact mail from the given user to the support email address.
  def contact(text, user)
    @text = text
    @user = user
    @person, @company, = @user.person, @user.company
    mail(:subject => "Contact Form", :to => AppConfig[:support_email], :from => @user.email)
  end
end
