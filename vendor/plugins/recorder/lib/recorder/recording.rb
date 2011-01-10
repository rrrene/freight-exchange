module Recorder # :nodoc:
  # The Recording class provides the base for storing the changes detected by 
  # an Observer object.
  # 
  #   class Recording < Recorder::Recording
  #   end
  class Recording < ActiveRecord::Base
    self.abstract_class = true
    serialize :diff
    belongs_to :item, :polymorphic => true
  end
end