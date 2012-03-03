class Station < ActiveRecord::Base
  searchable

  def full_name
    "#{numeric_id} - #{name}"
  end

  def to_search # :nodoc:
    full_name.simplify
  end

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :numeric_id
  validates_uniqueness_of :numeric_id
end
