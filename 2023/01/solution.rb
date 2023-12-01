require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# input = helper.line_separated_strings('input.txt')
# sample_input = helper.line_separated_strings('sample_input.txt')
input = helper.auto_parse
sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)



# Part 1
a = input.map do |s|
  nums = s.chars.filter do |c|
    /\d/ =~ c
  end
  (nums.first + nums.last).to_i
end .sum

# Part 2
vals = { one: 1, two: 2, three: 3, four: 4, five: 5, six: 6, seven: 7, eight: 8, nine: 9 }
b = input.map do |s|
  nums = s.scan(/(?=(\d|six|one|two|three|four|five|seven|eight|nine))/).flatten
  nums.map! do |num|
    if /\d/ =~ num
      num
    else
      vals[num.to_sym].to_s
    end
  end
  # p [s, nums, (nums.first + nums.last).to_i]
  (nums.first + nums.last).to_i
end .sum



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
