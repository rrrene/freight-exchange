# Freight objects are postings for freight.
# 
# They have two SiteInfo objects attached for their origin and destination 
# and several LocalizedInfo objects to describe the posting.
#
class Freight < ActiveRecord::Base
  SITE_ATTRIBUTES = %w(name address address2 zip city country)
  ORIGIN_ATTRIBUTES = SITE_ATTRIBUTES.map { |s| "origin_#{s}" }
  DESTINATION_ATTRIBUTES = SITE_ATTRIBUTES.map { |s| "destination_#{s}" }
  
  TRANSPORT_TYPE_CHOICES = %w(unknown single_wagon train_set block_train intermodal_transport)
  DESIRED_PROPOSAL_TYPE_CHOICES = %w(unknown ton_price package_price)
  WAGONS_PROVIDED_BY_CHOICES = %w(client railway wanted)
  PAYING_FREIGHT_CHOICES = %w(unknown sender receiver)
  FREQUENCY_CHOICES = %w(once repeated_regularly repeated_irregularly)
  belongs_to :user
  belongs_to :company

  belongs_to :origin_station, :class_name => 'Station'
  belongs_to :destination_station, :class_name => 'Station'
  belongs_to :contact_person, :class_name => 'Person'
  has_many :matching_recordings, :as => 'a', :order => 'result DESC', :dependent => :destroy
  after_save :calc_matchings!
  searchable
  
  include ActiveRecord::HasLocalizedInfos
  def localized_infos=(array_of_hashes) # :nodoc:
    localized_infos!(array_of_hashes)
  end
  
  # Calculates and saves all matching results for the freight.
  def calc_matchings!
    LoadingSpace.all.each do |record|
      result = Matching.fls(self, record)
      if matching = matching_recordings.where(:b_type => record.class.to_s, :b_id => record.id).first
        matching.update_attribute(:result, result)
      else
        matching_recordings.create(:b => record, :result => result)
      end
    end
  end
  
  # Returns the given number of matching loading space objects for the freight.
  def matching_loading_spaces(limit = 3)
    matching_recordings.limit(limit).map(&:b)
  end
  alias matching_objects matching_loading_spaces
  
  def name # :nodoc:
    "#{origin_name} - #{destination_name}"
  end
  
  def pretty_prefix
    '#NF'
  end
  
  def to_search # :nodoc:
    search_str = [
      # origin_city etc.
    ] * "\n"
    
    I18n.available_locales.each do |lang|
      search_str << "\n" << [
        localized_infos.where(:lang => lang.to_s).all.map(&:text) * "\n",
        hazmat? ? I18n.t('activerecord.attributes.freight.hazmat', :locale => lang, :default => '') : nil,
        human_attribute_values_in(lang, [:transport_type, :wagons_provided_by, :desired_proposal_type]),
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
  
  validates_presence_of :origin_city
  validates_presence_of :origin_country
  validates_presence_of :destination_city
  validates_presence_of :destination_country
  
  validates_presence_of :weight
  validates_presence_of :loading_meter
  validates_inclusion_of :hazmat, :in => [true, false]
  validates_inclusion_of :transport_type, :in => TRANSPORT_TYPE_CHOICES
  validates_inclusion_of :wagons_provided_by, :in => WAGONS_PROVIDED_BY_CHOICES
  validates_inclusion_of :desired_proposal_type, :in => DESIRED_PROPOSAL_TYPE_CHOICES
end
