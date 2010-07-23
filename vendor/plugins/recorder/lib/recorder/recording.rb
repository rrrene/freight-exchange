module Recorder # :nodoc:
  # The Recording class provides the base for storing the changes detected by 
  # an Observer object.
  # 
  class Recording < ActiveRecord::Base
    serialize :diff
    belongs_to :item, :polymorphic => true
  end
end