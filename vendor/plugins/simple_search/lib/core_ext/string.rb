
class String
  #:call-seq:
  #   str.simplify => string
  #
  # Replaces european accents and umlauts with their simple counterparts
  # ä -> a, ç -> c, etc.
  #   "René Föhring".simplify #=> "Rene Fohring"
  def simplify
    gsub(/[àáâãäåæ]/i, 'a').
    gsub(/[ç]/i, 'c').
    gsub(/[èéêë]/i, 'e').
    gsub(/[ìíîï]/i, 'i').
    gsub(/[ñ]/i, 'n').
    gsub(/[òóôõöø]/i, 'o').
    gsub(/[ùúûü]/i, 'u').
    gsub(/[ýÿ]/i, 'y')
  end
end