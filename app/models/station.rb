class Station < ActiveRecord::Base
  SITE_ATTRIBUTES = %w(name address address2 zip city country)
  has_and_belongs_to_many :regions, :uniq => true
  belongs_to :country
  searchable
  
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
