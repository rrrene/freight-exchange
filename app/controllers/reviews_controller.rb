class ReviewsController < RemoteController
  def new
    @review = Review.new(params[:review])
    @review.company_id = params[:company_id]
    new!
  end
  
  def approve
    @review = Review.find(params[:id])
    if @review.company == current_company
      @review.approved_by_id = current_user.id
      @review.save
    end
    redirect_to @review
  end
  
  def create
    @review = Review.new(params[:review])
    @company = @review.company
    @review.author_user_id = current_user.id
    @review.author_company_id = current_company.id
    create!
  end
  
  def index
    @reviews = current_company.reviews
    index!
  end
end
