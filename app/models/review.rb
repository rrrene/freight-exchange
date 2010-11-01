class Review < ActiveRecord::Base
  belongs_to :author_user, :class_name => 'User'
  belongs_to :author_company, :class_name => 'Company'
  belongs_to :company
  searchable
  
  def approved?
    approved_by_id.full?
  end
  
  def name
    company.full?(&:name)
  end
  
  validates_presence_of :text
end
