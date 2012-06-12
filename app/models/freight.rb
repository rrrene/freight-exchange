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
  DESIRED_PROPOSAL_TYPE_CHOICES = %w(ton_price package_price unknown)
  WAGONS_PROVIDED_BY_CHOICES = %w(client railway wanted)
  PAYING_FREIGHT_CHOICES = %w(unknown sender receiver)
  FREQUENCY_CHOICES = %w(once weekly monthly yearly)
  PRODUCT_STATE_CHOICES = %w(liquid gas loose packaged container)
  DESIRED_MEANS_OF_TRANSPORT_CHOICES = (0..9).to_a.map { |x| "wagon_#{x}" } + %w(custom)
  OWN_MEANS_OF_TRANSPORT_CHOICES = DESIRED_MEANS_OF_TRANSPORT_CHOICES
  OWN_MEANS_OF_TRANSPORT_PRESENT_CHOICES = [true, false]

  belongs_to :user
  belongs_to :company

  belongs_to :reply_to, :class_name => 'LoadingSpace'
  belongs_to :parent, :class_name => 'Freight'

  belongs_to :origin_station, :class_name => 'Station'
  belongs_to :destination_station, :class_name => 'Station'
  belongs_to :contact_person, :class_name => 'Person'
  has_many :matching_recordings, :as => 'a', :order => 'result DESC', :dependent => :destroy

  after_save :calc_matchings!
  after_save :create_notification

  searchable

  has_and_belongs_to_many :company_roles, :uniq => true

  def contact_email
    contact_person.full?(&:email) || company.email
  end

  include ActiveRecord::HasLocalizedInfos
  def localized_infos=(array_of_hashes) # :nodoc:
    localized_infos!(array_of_hashes)
  end
  
  # Calculates and saves all matching results for the freight.
  def calc_matchings!
    LoadingSpace.all.each do |record|
      result = Matching.fls(self, record)
      unless result.nan?
        if matching = matching_recordings.where(:b_type => record.class.to_s, :b_id => record.id).first
          matching.update_attribute(:result, result)
        else
          matching_recordings.create(:b => record, :result => result)
        end
      end
    end
  end
  
  # Returns the given number of matching loading space objects for the freight.
  def matching_loading_spaces(limit = 3)
    matching_recordings.limit(limit).map(&:b)
  end
  alias matching_objects matching_loading_spaces
  
  def name # :nodoc:
    if parent.full?
      I18n.t("freights.common.negotiated_name")
    else
      "#{origin_name} - #{destination_name}"
    end
  end
  
  def pretty_prefix
    '#N'
  end
  
  def first_transport_at=(value)
    self[:first_transport_at] = begin
      if value =~ /^\d\d\.\d\d\d\d$/
        DateTime.strptime(value, "%m.%Y") # parse month and year only
      else
        value
      end
    end
    #raise value.inspect + " => " + self[:first_transport_at].inspect
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

  def create_notification
    if p = self.parent.full?
      Notification.create_for(p.company, self)
    end
  end
  
  validates_presence_of :user_id
  validates_presence_of :company_id
  
#  validates_presence_of :origin_city
#  validates_presence_of :origin_country
#  validates_presence_of :destination_city
#  validates_presence_of :destination_country
  
  validates_presence_of :contractor
  validates_presence_of :product_name
  validates_presence_of :valid_from
  validates_presence_of :valid_until
  
  validates_presence_of :total_weight
  validates_presence_of :transport_weight
  validates_inclusion_of :frequency, :in => FREQUENCY_CHOICES
  
  validates_inclusion_of :hazmat, :in => [true, false]
  # commented because upload excel does not include this dependency between hazmat => true and requiring the other fields
  #validates_presence_of :hazmat_class, :if => :hazmat
  #validates_presence_of :un_no, :if => :hazmat
  
  validates_inclusion_of :product_state, :in => PRODUCT_STATE_CHOICES
  validates_inclusion_of :desired_means_of_transport, :in => DESIRED_MEANS_OF_TRANSPORT_CHOICES
  validates_inclusion_of :desired_proposal_type, :in => DESIRED_PROPOSAL_TYPE_CHOICES
  
  validates_inclusion_of :own_means_of_transport_present, :in => [true, false]
  # commented because upload excel does not include these fields (own_means_of_transport & own_means_of_transport_custom)
  #validates_inclusion_of :own_means_of_transport, :in => OWN_MEANS_OF_TRANSPORT_CHOICES, :if => :own_means_of_transport_present
end
