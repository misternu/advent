require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.line_separated_strings('input.txt')
# sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)


input = helper.send(:open_file, 'input.txt').read
sample_input = helper.send(:open_file, 'sample_input.txt').read
input = input.split("\n\n").map { |p| p.split("\n").map { |a| eval(a) } }

def compare(pair)
  a, b = pair
  
  if a.is_a?(Integer) && b.is_a?(Integer)
    return nil if a == b
    return a < b
  end

  if a.is_a?(Integer) && b.is_a?(Array)
    return compare([[a], b])
  end

  if a.is_a?(Array) && b.is_a?(Integer)
    return compare([a, [b]])
  end

  (0...a.length).each do |i|
    left, right = a[i], b[i]
    return false if b[i].nil?
    result = compare([left, right])
    next if result.nil?
    return result
  end
  a.length < b.length ? true : nil
end

total = 0
input.each_with_index do |pair, i|
  if compare(pair)
    total += i + 1
  end
end

# Part 1
a = total


# Part 2
input << [[[2]], [[6]]]
input = input.flatten(1)
order = input.sort do |a, b|
  value = compare([a, b])

  case value
  when true
    -1
  when nil
    0
  when false
    1
  end
end

b = (order.index([[2]]) + 1) * (order.index([[6]]) + 1)



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
