class Admin::ActionRecordingsController < Admin::BaseController
  def index
    @action_recordings = if request.xhr?
      last_id = params[:last_id].to_i
      @action_recordings = ActionRecording.where(['id > ?', last_id]).order('created_at DESC')
      obj = {
        :live_content => render_to_string(:partial => '/partials/recordings.html', :locals => {:recordings => @action_recordings}),
        :last_id => @action_recordings.first.id,
      }
      render :text => JSON[obj]
    else
      ActionRecording.order('created_at DESC').limit(20)
    end
  end
end
