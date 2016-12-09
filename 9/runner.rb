string = File.open('input.txt').read

def matches(string)
  /([^\(]*)\((\d+)x(\d+)\)(.*)/.match(string).captures
end

def v1(string)
  return string.length unless string.include?('(')
  before, l, c, after = matches(string)
  l, c = l.to_i, c.to_i
  return before.length + l * c + v1(after[l..-1])
end

def v2(string)
  return string.length unless string.include?('(')
  before, l, c, after = matches(string)
  l, c = l.to_i, c.to_i
  return before.length + c * v2(after[0...l]) + v1(after[l..-1])
end

puts v1(string)
puts v2(string)