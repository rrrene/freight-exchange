# ActionRecording objects inherit from Recorder::Recording and are logs of user
# actions in the app.
#
# They belong to a user and his company, so company or user specific reports
# can be created.
# 
# GeneralObserver creates ActionRecording objects whenever an
# user editable record is created, updated or deleted in the
# app.
class ActionRecording < Recorder::Recording
  belongs_to :user
  belongs_to :company
end
