class PostingsController < ApplicationController
  login_required
  
  def show
    @posting = Posting.find(params[:id])
  end
end
