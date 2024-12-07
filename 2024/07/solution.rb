require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__)
# input = helper.send(:open_file, 'input.txt').read
# input = helper.line_separated_strings('input.txt')
# input = helper.comma_separated_strings('input.txt')
input = helper.auto_parse
# sample_input = helper.line_separated_strings('sample_input.txt')
sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

input = input.map { |l| l.map(&:to_i) }

# Part 1
def values(numbers)
  return numbers if numbers.length == 1

  last = numbers[-1]
  front = values(numbers[...-1])
  result = front.map { |v| last + v }
  result += front.map { |v| last * v }
  result
end

a = 0

input.each do |line|
  target = line[0]
  numbers = line[1..]
  a += target if values(numbers).include?(target)
end

# Part 2

def search(target, numbers, val, i)
  if i == numbers.length
    return val == target ? target : 0
  end

  concat = (val.to_s + numbers[i].to_s).to_i
  if concat <= target
    result = search(target, numbers, concat, i + 1)
    return result if result > 0
  end

  product = val * numbers[i]
  if product <= target
    result = search(target, numbers, product, i + 1)
    return result if result > 0
  end

  sum = val + numbers[i]
  if sum <= target
    result = search(target, numbers, sum, i + 1)
    return result if result > 0
  end

  0
end

b = 0

input.each do |line|
  target = line[0]
  numbers = line[1..]
  b += search(target, numbers, numbers[0], 1)
end

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
