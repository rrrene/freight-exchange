class MatchingRecording < ActiveRecord::Base
  belongs_to :a, :polymorphic => true
  belongs_to :b, :polymorphic => true
  
  def self.update!(records = Freight.all)
    records = [records] unless records.is_a?(Array)
    records.each(&:calc_matchings!)
  end
  
  validates_presence_of :result
end
