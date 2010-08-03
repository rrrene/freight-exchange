class Country < ActiveRecord::Base
  validates_uniqueness_of :iso
end
