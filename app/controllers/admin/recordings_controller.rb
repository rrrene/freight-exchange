class Admin::RecordingsController < Admin::BaseController
  def index
    @recordings = Recording.limit(20).order('created_at DESC')
  end
end
