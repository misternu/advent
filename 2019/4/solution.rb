def ascends(digits)
  (0...digits.length-1).all? { |i| digits[i] >= digits[i + 1] }
end

range = (130254..678275)
part1 = 0
part2 = 0

range.each do |num|
  digits = num.digits
  if ascends(digits)
    if (1..9).any? { |i| digits.count(i) == 2 }
      part1 += 1
      part2 += 1
    elsif (1..9).any? { |i| digits.count(i) > 1 }
      part1 += 1
    end
  end
end

p part1
p part2
