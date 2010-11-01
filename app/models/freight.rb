
class Freight < ActiveRecord::Base
  TRANSPORT_TYPE_CHOICES = %w(single_wagon train_set block_train)
  DESIRED_PROPOSAL_TYPE_CHOICES = %w(ton_price package_price)
  WAGONS_PROVIDED_BY_CHOICES = %w(client railway)
  belongs_to :user
  belongs_to :company
  belongs_to :origin_site_info, :class_name => 'SiteInfo', :dependent => :destroy
  belongs_to :destination_site_info, :class_name => 'SiteInfo', :dependent => :destroy
  accepts_nested_attributes_for :origin_site_info
  accepts_nested_attributes_for :destination_site_info
  has_many :matching_recordings, :as => 'a', :order => 'result DESC'
  belongs_to :contact_person, :class_name => 'Person'
  after_save :calc_matchings!
  searchable
  
  include ActiveRecord::HasLocalizedInfos
  def localized_infos=(array_of_hashes)
    localized_infos!(array_of_hashes)
  end
  
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

  def matching_loading_spaces(limit = 3)
    matching_recordings.limit(limit).map(&:b)
  end
  alias matching_objects matching_loading_spaces
  
  def to_search
    search_str = [
      origin_site_info.to_search,
      destination_site_info.to_search,
      
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
  validates_presence_of :weight
  validates_inclusion_of :hazmat, :in => [true, false]
  validates_inclusion_of :transport_type, :in => TRANSPORT_TYPE_CHOICES
  validates_inclusion_of :wagons_provided_by, :in => WAGONS_PROVIDED_BY_CHOICES
  validates_inclusion_of :desired_proposal_type, :in => DESIRED_PROPOSAL_TYPE_CHOICES
end
