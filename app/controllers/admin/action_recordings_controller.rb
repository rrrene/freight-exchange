class Admin::ActionRecordingsController < Admin::BaseController
  def index
    @action_recordings = if request.xhr?
      render :text => ActionRecording.where(['created_at > ?', params[:timestamp].to_i]).count.to_s
    else
      ActionRecording.order('created_at DESC').limit(20)
    end
  end
end
