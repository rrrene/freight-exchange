# Person objects contain personal information about a User.
# 
class Person < ActiveRecord::Base
  GENDER_CHOICES = %w(male female)
  LOCALE_CHOICES = I18n.available_locales.map(&:to_s)
  has_one :user
  has_one :company, :through => :user
  searchable
  
  include ActiveRecord::HasLocalizedInfos
  def localized_infos=(array_of_hashes)
    localized_infos!(array_of_hashes)
  end
  
  # TODO: Anrede?
  def name
    "#{first_name} #{last_name}"
  end
  
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_inclusion_of :gender, :in => GENDER_CHOICES
  validates_presence_of :locale, :in => LOCALE_CHOICES
end
