class WhiteListedItemsController < RemoteController
  def create
    @white_listed_item = WhiteListedItem.new(params[:white_listed_item])
    @white_listed_item.company = current_company
    create!
  end

  def destroy_all
    p = params[:white_listed_item]
    current_company.white_listed_items.where(:item_type => p[:item_type], :item_id => p[:item_id]).each(&:destroy)
    redirect_to :controller => p[:item_type].pluralize.underscore, :action => :show, :id => p[:item_id]
  end

  def show
    redirect_to resource.item
  end
end
