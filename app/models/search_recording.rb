class SearchRecording < ActiveRecord::Base
  belongs_to :user
  belongs_to :parent, :class_name => 'SearchRecording', :foreign_key => 'parent_id'
  belongs_to :result, :polymorphic => true
  
  validates_presence_of :user_id
end
