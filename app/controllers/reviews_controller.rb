class ReviewsController < InheritedResources::Base
  api_enabled
  login_required
  
  def new
    @review = Review.new(params[:review])
    @review.company_id = params[:company_id]
    new!
  end
  
  def create
    @review = Review.new(params[:review])
    @company = @review.company
    @review.author_user_id = current_user.id
    @review.author_company_id = current_company.id
    create!
  end
end
