class SiteInfo < ActiveRecord::Base
  validates_presence_of :contractor
  validates_presence_of :address
  validates_presence_of :zip
  validates_presence_of :city
  validates_presence_of :country
  validates_presence_of :side_track_avaiable
end
