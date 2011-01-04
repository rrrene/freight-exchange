# SiteInfo objects contain information about loading and unloading sites, 
# such as name of the site, address of the site, name of the contractor etc.
#
class SiteInfo < ActiveRecord::Base
  SITE_ATTRIBUTES = %w(name address address2 zip city country)
#  validates_presence_of :address
#  validates_presence_of :zip
#  validates_presence_of :city
#  validates_presence_of :country

  def to_search # :nodoc:
    [
      contractor,
      I18n.available_locales.map { |lang| 
        I18n.l(date, :locale => lang, :format => :long)
      }, 
      name,
      address,
      address2,
      zip, 
      city,
      country
    ].map(&:full?).compact.join("\n").simplify
  end

  validates_presence_of :contractor
  validates_presence_of :name
  validates_inclusion_of :side_track_available, :in => [true, false]
end
