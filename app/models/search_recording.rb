# SearchRecording objects are logs of the search queries performed by users.
#
class SearchRecording < ActiveRecord::Base
  belongs_to :user
  belongs_to :parent, :class_name => 'SearchRecording', :foreign_key => 'parent_id'
  belongs_to :result, :polymorphic => true
  has_many :children, :class_name => 'SearchRecording', :foreign_key => 'parent_id'
  
  #:call-seq:
  #   recording.clicks # => int
  #
  # Returns the number of clicked search results for this search.
  def clicks
    children.count
  end
  
  validates_presence_of :user_id
end
