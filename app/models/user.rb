require 'digest/sha1'
# User objects respresent a user of the app and are used to authenticate 
# users upon login (using acts_as_authentic plugin) and handle 
# permission handling via assigned UserRole objects. 
#
# Data concerning the actual, human user (like company, gender, language etc.)
# is stored in associated Person and Company objects.
class User < ActiveRecord::Base
  API_KEY_SECRET = "85b66e91fb5929d86f205b82"
  belongs_to :company
  belongs_to :person
  accepts_nested_attributes_for :company
  accepts_nested_attributes_for :person
  has_and_belongs_to_many :user_roles, :uniq => true
  has_many :search_recordings
  before_create :generate_api_key
  after_save { |user| user.company.ensure_admin }
  after_destroy { |user| user.company.ensure_admin }
  brackets_find_by :login
  acts_as_authentic
  searchable :attributes => ["posting_type", "current_login_ip", "login", "email"]
  
  #:call-seq:
  #   user.has_role?(role_name) # => boolean
  #
  # Returns true if a user has a UserRole with the given <tt>name</tt>.
  #   user.has_role?(:administrator) # => true
  def has_role?(name)
    roles.include?(name.to_s)
  end
  alias is? has_role?
  
  def name # :nodoc:
    person.full?(&:name)
  end
  
  def postings
    @postings ||= self.company.__send__(self.posting_type.underscore.pluralize)
  end
  
  def recent_site_infos(origin_or_destination = nil)
    if origin_or_destination
      postings.map(&:"#{origin_or_destination}_site_info")
    else
      postings.map(&:origin_site_info) + postings.map(&:destination_site_info)
    end
  end
  
  #:call-seq:
  #   user.roles # => array
  #
  # Returns an array of role names.
  #   user.roles # => ["administrator", "company_admin"]
  def roles
    @roles ||= user_roles.map(&:name)
  end
  
  #:call-seq:
  #   user.search_type # => string
  #
  # Returns the type of postings the user is searching for, i.e. 
  # freights if the user is posting loading space and vice versa.
  #   user.posting_type # => "Freight"
  #   user.search_type # => "LoadingSpace"
  def search_type
    posting_type == 'Freight' ? 'LoadingSpace' : 'Freight'
  end
  
  # For permission handling
  def user # :nodoc:
    self
  end
  
  private
  
  def generate_api_key
    pattern = "#{created_at}-#{login}-#{API_KEY_SECRET}"
    self.api_key = Digest::SHA1.hexdigest(pattern)
  end
  
end