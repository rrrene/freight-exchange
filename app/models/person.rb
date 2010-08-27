# Person objects contain personal information about a User.
# 
class Person < ActiveRecord::Base
  GENDER_CHOICES = %w(male female)
  LOCALE_CHOICES = I18n.available_locales.map(&:to_s)
  has_one :user
  searchable
  
  # TODO: Anrede?
  def name
    "#{first_name} #{last_name}"
  end
  
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_inclusion_of :gender, :in => GENDER_CHOICES
  validates_presence_of :locale, :in => LOCALE_CHOICES
end
