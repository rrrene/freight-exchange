# MatchingRecording objects are used to save the results of 
# matching operations.
class MatchingRecording < ActiveRecord::Base
  belongs_to :a, :polymorphic => true
  belongs_to :b, :polymorphic => true
  
  #:call-seq:
  #   MatchingRecording.update!
  #
  # Recalculates and updates the matching results for all given 
  # Freight objects (defaults to all).
  def self.update!(records = Freight.all)
    records = [records] unless records.is_a?(Array)
    records.each(&:calc_matchings!)
  end
  
  validates_presence_of :result
end
