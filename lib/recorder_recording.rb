module Recorder
  class Recording < ActiveRecord::Base
    serialize :diff
    belongs_to :item, :polymorphic => true
  end
end