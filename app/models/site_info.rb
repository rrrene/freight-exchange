class SiteInfo < ActiveRecord::Base
  validates_presence_of :contractor
#  validates_presence_of :address
#  validates_presence_of :zip
#  validates_presence_of :city
#  validates_presence_of :country

  def to_search
    [
      contractor,
      I18n.available_locales.map { |lang| 
        I18n.l(date, :locale => lang, :format => :long) 
      }, 
      name,
      address,
      address2,
      zip, city,
      country
    ].map(&:full?).compact.join("\n").simplify
  end

  validates_inclusion_of :side_track_available, :in => [true, false]
end
