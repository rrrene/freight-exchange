class Person < ActiveRecord::Base
  GENDER_CHOICES = %w(male female)
  has_one :user
  searchable
  
  def name # TODO: Anrede?
    "#{first_name} #{last_name}".full?
  end
  
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_inclusion_of :gender, :in => GENDER_CHOICES
end
