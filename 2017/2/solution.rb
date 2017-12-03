def solution(input)
  input.reduce(0) do |memo, line|
    memo + (line.max - line.min)
  end
end

def solution2(input)
  input.reduce(0) do |memo, line|
    pair = line.combination(2).find do |pair|
      pair.max % pair.min == 0
    end
    memo + (pair.max / pair.min)
  end
end
