
class Object
  def is_a_or_an_array_of?(klass)
    test_object = self.is_a?(Array) ? self.first : self
    test_object.is_a?(klass)
  end  
end
