class ReviewsController < RemoteController
  login_required
  same_company_required :except => %w(index new create created)
  
  def new
    @review = Review.new(params[:review])
    if company_id = params[:company_id]
      @review.company_id = company_id
    else
      raise "Parameter error: company_id required" 
    end
    @company = @review.company
    page[:title] = @company.name
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
    if @review.save
      respond_to do |format|
        format.html { redirect_to :action => :created }
      end
    end
  end
  
  def filter_collection!
    filter = params[:filter].full?(&:to_s).full?(&:intern)
    @reviews = if filter == :approved
      current_company.approved_reviews
    elsif filter == :unapproved
      current_company.unapproved_reviews
    else
      current_company.reviews
    end
  end
  
  def default_order_param
    :id
  end
end
