def next_ascending(number)
  iterate = (number + 1)
  digits = iterate.digits.reverse
  (0...digits.length-1).each do |i|
    if digits[i] > digits[i+1]
      return digits.fill(digits[i], i+1).inject{|a,i| a*10 + i}
    end
  end
  iterate
end

min = 130254
max = 678275

ascending_passwords = Enumerator.new do |enum|
  i = next_ascending(min - 1)
  while i <= max
    enum.yield i
    i = next_ascending(i)
  end
end

part1 = 0
part2 = 0

ascending_passwords.each do |pass|
  digits = pass.digits
  if (1..9).any? { |i| digits.count(i) == 2 }
    part1 += 1
    part2 += 1
  elsif (1..9).any? { |i| digits.count(i) > 1 }
    part1 += 1
  end
end

p part1
p part2