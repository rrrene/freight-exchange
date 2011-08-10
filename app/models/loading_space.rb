# LoadingSpace objects are postings for loading space.
# 
# They have two SiteInfo objects attached for their origin and destination 
# and several LocalizedInfo objects to describe the posting.
#
class LoadingSpace < ActiveRecord::Base
  SITE_ATTRIBUTES = %w(name address address2 zip city country)
  ORIGIN_ATTRIBUTES = SITE_ATTRIBUTES.map { |s| "origin_#{s}" }
  DESTINATION_ATTRIBUTES = SITE_ATTRIBUTES.map { |s| "destination_#{s}" }

  TRANSPORT_TYPE_CHOICES = ::Freight::TRANSPORT_TYPE_CHOICES
  FREQUENCY_CHOICES = %w(once repeated_regularly repeated_irregularly)
  belongs_to :user
  belongs_to :company
  belongs_to :reply_to, :class_name => 'Freight'

  belongs_to :origin_station, :class_name => 'Station'
  belongs_to :destination_station, :class_name => 'Station'
  belongs_to :contact_person, :class_name => 'Person'
  has_many :matching_recordings, :as => 'b', :order => 'result DESC', :dependent => :destroy
  searchable

  def contact_email
    contact_person.full?(&:email) || company.email
  end

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
    "#{origin_name} - #{destination_name}"
  end
  
  def pretty_prefix
    '#A'
  end
  
  def to_search # :nodoc:
    search_str = [:origin, :destination].map { |origin_or_destination|
      [
        self.__send__("#{origin_or_destination}_station").full? { |station|
          [
            station.name, station.numeric_id
          ]
        },
        SITE_ATTRIBUTES.map { |field|
          self.__send__("#{origin_or_destination}_#{field}").full?
        }
      ]
    }.flatten.compact * "\n"
    
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
  #validates_presence_of :weight
  #validates_presence_of :loading_meter
  validates_inclusion_of :hazmat, :in => [true, false]
  validates_inclusion_of :transport_type, :in => TRANSPORT_TYPE_CHOICES
end
