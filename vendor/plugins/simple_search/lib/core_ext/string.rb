
class String
  def simplify
    gsub(/[àáâãäåæ]/i, 'a').
    gsub(/[ç]/i, 'c').
    gsub(/[èéêë]/i, 'e').
    gsub(/[ìíîï]/i, 'i').
    gsub(/[ñ]/i, 'n').
    gsub(/[òóôõöø]/i, 'o').
    gsub(/[ùúûü]/i, 'u').
    gsub(/[ýÿ]/i, 'y').
    to_s
  end
end