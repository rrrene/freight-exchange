class Recording < Recorder::Recording
  belongs_to :user
  belongs_to :company
end