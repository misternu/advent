require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)
# input = sample_input



# Part 1
def validate(line)
  stack = []
  line.split('').each do |char|
    case char
    when "("
      stack << char
    when "["
      stack << char
    when "{"
      stack << char
    when "<"
      stack << char
    when ")"
      return char unless stack.last == "("
      stack = stack[0...-1]
    when "]"
      return char unless stack.last == "["
      stack = stack[0...-1]
    when "}"
      return char unless stack.last == "{"
      stack = stack[0...-1]
    when ">"
      return char unless stack.last == "<"
      stack = stack[0...-1]
    end
  end
  nil
end
errors = input.map { |l| validate(l) } .compact
a = errors.sum do |error|
  { ")" => 3, "]" => 57, "}" => 1197, ">" => 25137 }[error]
end

# Part 2
def complete(line)
  stack = []
  line.split('').each do |char|
    case char
    when "("
      stack << char
    when "["
      stack << char
    when "{"
      stack << char
    when "<"
      stack << char
    when ")"
      return nil unless stack.last == "("
      stack = stack[0...-1]
    when "]"
      return nil unless stack.last == "["
      stack = stack[0...-1]
    when "}"
      return nil unless stack.last == "{"
      stack = stack[0...-1]
    when ">"
      return nil unless stack.last == "<"
      stack = stack[0...-1]
    end
  end
  completion = stack.reverse.map do |char|
    { "(" => ")", "[" => "]", "{" => "}", "<" => ">" }[char]
  end
  score = 0
  completion.each do |char|
    score = score * 5
    score += { ")" => 1, "]" => 2, "}" => 3, ">" => 4 }[char]
  end
  score
end
scores = input.map { |l| complete(l) } .compact

b = scores.sort[scores.length / 2]



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
