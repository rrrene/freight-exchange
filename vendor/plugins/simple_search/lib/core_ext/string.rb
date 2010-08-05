
class String
  #:call-seq:
  #   str.simplify => string
  #
  # Replaces european accents and umlauts with their simple counterparts
  # and downcases the result.
  # ä -> a, ç -> c, etc.
  #   "René Föhring".simplify #=> "rene fohring"
  def simplify
    gsub(/[àáâãäåæâ]/i, 'a').
    gsub(/[ç]/i, 'c').
    gsub(/[èéêëeê]/i, 'e').
    gsub(/[ìíîïî]/i, 'i').
    gsub(/[ñ]/i, 'n').
    gsub(/[òóôõöøô]/i, 'o').
    gsub(/[ùúûüû]/i, 'u').
    gsub(/[ýÿ]/i, 'y').
    downcase
  end
end