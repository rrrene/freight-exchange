#!/usr/bin/env ruby -wKU

class Array
  def random
    sort_by { rand * 2 - 1 }.first
  end
end
