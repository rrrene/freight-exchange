class Freight < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  belongs_to :origin_site_info, :class_name => 'SiteInfo', :dependent => :destroy
  belongs_to :destination_site_info, :class_name => 'SiteInfo', :dependent => :destroy
  accepts_nested_attributes_for :origin_site_info
  accepts_nested_attributes_for :destination_site_info
  has_many :localized_infos, :as => :item
  
  def localized_info(name, lang = I18n.default_locale)
    localized_infos.select { |obj| 
      (obj.name == name.to_s) && (obj.lang == lang.to_s) 
    }.first.full? || localized_infos.build(:name => name.to_s, :lang => lang.to_s)
  end
  
#  accepts_nested_attributes_for :localized_infos
  
  validates_presence_of :user_id
  validates_presence_of :company_id
  validates_presence_of :weight
  validates_inclusion_of :hazmat, :in => [true, false]
end
