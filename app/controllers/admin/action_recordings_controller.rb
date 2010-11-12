class Admin::ActionRecordingsController < Admin::BaseController
  def index
    @action_recordings = ActionRecording.limit(20).order('created_at DESC')
  end
end
