#!/usr/bin/env ruby -wKU

class Array
  def random
    if methods.include?("rand")
      rand
    else
      sort_by { rand * 2 - 1 }.first
    end
  end
end
