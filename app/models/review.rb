class Review < ActiveRecord::Base
  belongs_to :author, :foreign_key => 'author_user_id'
  belongs_to :company
  searchable
  
  validates_presence_of :text
end
