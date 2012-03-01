class CompanyRole < ActiveRecord::Base
  brackets_find_by :name
  has_and_belongs_to_many :companies, :uniq => true

  validates_uniqueness_of :name, :case_insensitive => false
end
