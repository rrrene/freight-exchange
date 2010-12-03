class ContactController < ApplicationController
  login_required
  
  def index
    if request.post?
      if text = params[:text].full?
        Contact.contact(text, current_user).deliver
        redirect_to :sent => true
      end
    end
  end

end
