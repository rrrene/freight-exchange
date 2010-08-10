class ActiveRecord::Base
  def belongs_to?(user = current_user)
    self.user == user
  end
  alias mine? belongs_to?
  
  class << self
    # Adds a convenient [] find_by to the model utilizing the given attribute
    # and returning the first record matching the condition. Therefore this
    # is best used on attributes that go through validates_uniqueness_of.
    #
    #   class Country < ActiveRecord::Base
    #     brackets_find_by :iso_code
    #   end
    #   
    #   Country[:de] => #<Country id: 1, name: "Germany", iso_code: "de">
    def brackets_find_by(attribute_name)
      self.instance_eval "
        def [](val)
          where(:#{attribute_name} => val.to_s).first
        end
      "
    end
  end
end