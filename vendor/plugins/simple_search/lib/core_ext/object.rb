
class Object
  #:call-seq:
  #   obj.is_a_or_an_array_of?(klass) => true or false
  #
  # Returns true if klass is the class or a superclass of obj,
  # or if obj is an array of objects of the class.
  def is_a_or_an_array_of?(klass)
    if self.is_a?(Array) 
      self.all? { |obj| obj.is_a?(klass) }
    else
      self.is_a?(klass)
    end
  end  
end
