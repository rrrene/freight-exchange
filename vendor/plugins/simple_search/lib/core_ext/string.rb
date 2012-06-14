# encoding: UTF-8

class String
  #:call-seq:
  #   str.simplify => string
  #
  # Replaces european accents and umlauts with their simple counterparts
  # and downcases the result.
  # ä -> a, ç -> c, etc.
  #   "René Föhring".simplify #=> "Rene Fohring"
  def simplify
    gsub(/(à|À|á|Á|â|Â|ã|ä|Ä|å|æ)/, 'a').
    gsub(/(ç)/, 'c').
    gsub(/(è|È|é|É|ê|Ê|ë)/, 'e').
    gsub(/(ì|Ì|í|Í|î|Î|ï)/, 'i').
    gsub(/(ñ)/, 'n').
    gsub(/(ò|Ò|ó|Ó|õ|ö|Ö|ø|ô|Ô)/, 'o').
    gsub(/(ù|Ù|ú|Ú|û|Û|ü|Ü)/, 'u').
    gsub(/(ý|Ý|ÿ)/, 'y')
  end
end