
# Coolest snippet of code ever.
class ::Object
  def full?
    f = blank? ? nil : self
    if block_given? and f
      yield f
    else
      f
    end
  end
end
