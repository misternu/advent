require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__, counter: false)
# input = helper.send(:open_file, 'input.txt').read
# input = helper.line_separated_strings('input.txt')
# sample_input = helper.line_separated_strings('sample_input.txt')
input = helper.line_separated_strings('input.txt')
# sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)
# input = sample_input

# Part 1
rows = input.map do |s|
  string, nums = s.split(' ')
  [string, nums.split(',').map(&:to_i)]
end

def count_poss(string, nums, i = 0, j = 0, memo = {}, c = 0)
  return memo[[i, j]] if memo[[i, j]]

  if i >= string.length
    if j == nums.length
      memo[[i, j]] = 1
      return 1
    else
      memo[[i, j]] = 0
      return 0
    end
  end

  if '.?'.include?(string[i])
    c += count_poss(string, nums, i + 1, j, memo)
  end

  if j == nums.length
    memo[[i, j]] = c
    return c
  end

  k = i + nums[j]
  if k <= string.length && !string[i...k].include?('.') && string[k] != '#'
    c += count_poss(string, nums, k + 1, j + 1, memo)
  end

  memo[[i, j]] = c
  c
end

a = 0

rows.each do |row|
  count = count_poss(row[0], row[1])
  a += count
end

# Part 2
b = 0

rows.each do |row|
  count = count_poss(
    5.times.collect { row[0] }.join("?"),
    row[1] * 5
  )
  b += count
end

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
