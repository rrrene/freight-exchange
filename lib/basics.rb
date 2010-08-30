

class ::Object
  #:call-seq:
  #   obj.full?
  #   obj.full? { |f| ... }
  #
  # Returns wheter or not the given obj is not blank?.
  # If a block is given and the obj is full?, the obj is yielded to that block.
  # 
  #   salary = nil
  #   salary.full? # => nil
  #   salary.full? { |s| "#{s} $" } # => nil
  #   salary = 100
  #   salary.full? { |s| "#{s} $" } # => "100 $"
  # 
  # With Rails' implementation of Symbol#to_proc it is possible to write:
  # 
  #   current_user.full?(&:name) # => "Dave"
  def full?
    f = blank? ? nil : self
    if block_given? and f
      yield f
    else
      f
    end
  end
end
