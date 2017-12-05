def solution(input)
  input.count do |phrase|
    has_no_repeats(phrase)
  end
end

def solution2(input)
  input.count do |phrase|
    has_no_repeats(phrase) && has_no_anagrams(phrase)
  end
end

def has_no_repeats(phrase)
  phrase.uniq.length == phrase.length
end

def has_no_anagrams(phrase)
  phrase.combination(2).all? do |pair|
    !anagrams(pair[0], pair[1])
  end
end

def anagrams(a, b)
  a.split('').sort == b.split('').sort
end
