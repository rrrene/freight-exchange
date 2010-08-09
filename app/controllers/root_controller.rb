class RootController < ApplicationController
  
  def about
    page[:title] = t("root.about.page_title")
  end
  
  def index
  end

end
