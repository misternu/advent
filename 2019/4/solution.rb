min = 130254
max = 678275

def has_repeat(string)
  (0...string.length-1).any? do |i|
    string[i] == string[i + 1]
  end
end

def ascends(string)
  (0...string.length-1).all? do |i|
    string[i] <= string[i + 1]
  end
end

def has_a_double(string)
  (0...string.length-1).any? do |i|
    string.count(string[i]) == 2 && string[i] == string[i + 1]
  end
end

range = (min..max)
part1 = 0
part2 = 2

range.each do |num|
  string = num.to_s
  part1 += 1 if ascends(string) && has_repeat(string)
  part2 += 1 if ascends(string) && has_a_double(string)
end

p part1
p part2