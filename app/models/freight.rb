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
  has_many :localized_infos, :as => :item
  searchable
  
  def localized_infos=(array_of_options)
    array_of_options.each do |opts|
      self.localized_info(opts[:name], opts[:lang]).text = opts[:text].full?
    end
  end
  
  def localized_info(name, lang = I18n.default_locale)
    localized_infos.select { |obj| 
      (obj.name == name.to_s) && (obj.lang == lang.to_s) 
    }.first.full? || localized_infos.build(:name => name.to_s, :lang => lang.to_s)
  end
  
  def update_localized_infos
    localized_infos.each(&:update_or_destroy!)
  end
  
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
