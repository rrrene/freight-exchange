# Review objects contain a text review of a company.
#
# They have to be approved by an user of that company to
# appear on their company's profile.
#
class Review < ActiveRecord::Base
  belongs_to :author_user, :class_name => 'User'
  belongs_to :author_company, :class_name => 'Company'
  belongs_to :company
  searchable

  after_create :create_notification
  
  # Returns <tt>true</tt>, if the review has been approved by a user.
  def approved?
    approved_by_id.full?
  end
  
  # Returns the name of the company of this review.
  def name
    company.full?(&:name)
  end

  private

  def create_notification
    Notification.create_for(company, self)
  end

  validates_presence_of :text
end
