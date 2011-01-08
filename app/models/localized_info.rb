# LocalizedInfo objects contain localized text snippets that can be associated with
# other objects, e.g. freights, people etc.
#
#   opts = {
#     :name => 'misc_text',
#     :lang => 'de',
#     :text => 'Etwas Text...',
#     :item => Person.find(1)
#   }
#   LocalizedInfo.create(opts)
class LocalizedInfo < ActiveRecord::Base
  belongs_to :item, :polymorphic => true
  
  #:call-seq:
  #   info.update_or_destroy!
  # 
  # Saves or destroys the object, whether its text is present or blank.
  def update_or_destroy!
    text.blank? ? destroy : save
  end
  
  validates_presence_of :name
  validates_presence_of :lang
  validates_presence_of :text
end
