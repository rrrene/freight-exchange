class Station < ActiveRecord::Base
  has_and_belongs_to_many :regions, :uniq => true
  belongs_to :country
  simple_search
  
  def to_search
    "
    [#{name}]
      #{country.name}
      #{regions.map(&:name) * ' '}
    ".simplify
  end
  
  validates_presence_of :country_id
  validates_uniqueness_of :name
end
