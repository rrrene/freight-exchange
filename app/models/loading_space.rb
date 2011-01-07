class LoadingSpace < ActiveRecord::Base
  TRANSPORT_TYPE_CHOICES = %w(single_wagon train_set block_train)
  belongs_to :user
  belongs_to :company
  belongs_to :origin_site_info, :class_name => 'SiteInfo', :dependent => :destroy
  belongs_to :destination_site_info, :class_name => 'SiteInfo', :dependent => :destroy
  accepts_nested_attributes_for :origin_site_info
  accepts_nested_attributes_for :destination_site_info
  belongs_to :contact_person, :class_name => 'Person'
  has_many :matching_recordings, :as => 'b', :order => 'result DESC', :dependent => :destroy
  searchable
  
  include ActiveRecord::HasLocalizedInfos
  def localized_infos=(array_of_hashes) # :nodoc:
    localized_infos!(array_of_hashes)
  end
  
  # Returns the given number of matching freight objects for the loading space.
  def matching_freights(limit = 3)
    matching_recordings.limit(limit).map(&:a)
  end
  alias matching_objects matching_freights
  
  def name # :nodoc:
    "#{origin_site_info.name} - #{destination_site_info.name}"
  end
  
  def to_search # :nodoc:
    search_str = [
      origin_site_info.to_search,
      destination_site_info.to_search,
      
    ] * "\n"
    
    I18n.available_locales.each do |lang|
      search_str << "\n" << [
        localized_infos.where(:lang => lang.to_s).all.map(&:text) * "\n",
        hazmat? ? I18n.t('activerecord.attributes.freight.hazmat', :locale => lang, :default => '') : nil,
        human_attribute_values_in(lang, [:transport_type]),
      ].flatten.compact * "\n"
    end
    search_str.simplify
  end
  
  private
  
  def human_attribute_values_in(lang, *values)
    values.flatten.map { |attr| 
      human_attribute_value(attr, :locale => lang, :default => '').full?
    }.compact
  end
  
  validates_presence_of :user_id
  validates_presence_of :company_id
  validates_presence_of :weight
  validates_presence_of :loading_meter
  validates_inclusion_of :hazmat, :in => [true, false]
  validates_inclusion_of :transport_type, :in => TRANSPORT_TYPE_CHOICES
end
