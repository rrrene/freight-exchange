class SearchRecording < ActiveRecord::Base
  belongs_to :user
  belongs_to :parent, :class_name => 'SearchRecording', :foreign_key => 'parent_id'
  belongs_to :result, :polymorphic => true
  has_many :children, :class_name => 'SearchRecording', :foreign_key => 'parent_id'
  
  def clicks
    children.count
  end
  
  validates_presence_of :user_id
end
