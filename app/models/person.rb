# Person objects contain personal information about a User.
# 
#   opts = {
#     :gender => 'male',
#     :first_name => 'Maximilian',
#     :last_name => 'Sprenkler',
#     :job_description => 'Chief Executive Officer',
#     :phone => '+49 (0) 234 569986-1',
#     :fax => '+49 (0) 234 569986-55',
#     :website => 'example.org/team/m.sprenkler',
#   }
#   user.person.create(opts)
# 
class Person < ActiveRecord::Base
  GENDER_CHOICES = %w(male female)
  LOCALE_CHOICES = %w(de)
  has_one :user
  has_one :company, :through => :user
  before_save :inherit_email_address
  searchable
  
  include ActiveRecord::HasLocalizedInfos
  def localized_infos=(array_of_hashes) # :nodoc:
    localized_infos!(array_of_hashes)
  end
  
  #:call-seq:
  #   person.name # => String
  #
  # Returns the full name of the person.
  def name
    "#{first_name} #{last_name}"
  end
  
  def website # :nodoc:
    address = self[:website]
    if address.blank? || address =~ /^\w+\:\/\//
      address
    else
      "http://#{address}"
    end
  end
  
  private
  
  def inherit_email_address
    if self[:email].blank? && self.user
      self[:email] = self.user.email
    end
  end
  
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_inclusion_of :gender, :in => GENDER_CHOICES
  validates_presence_of :locale, :in => LOCALE_CHOICES
end
