require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__)
input = helper.send(:open_file, 'input.txt').read
sample_input = helper.send(:open_file, 'sample_input.txt').read

# input = sample_input
input = input.chomp

# Part 1
digits = []
gaps = []

j = 0
input.split('').each_with_index do |digit, i|
  num = digit.to_i
  next if num == 0
  if i % 2 == 0
    digits << [i / 2, num]
    j += num
  else
    gaps << [j, j + num]
    j += num
  end
end

a = 0

i = 0
loop do
  if i != gaps.first.first
    a += digits.first.first * i
    digits[0][1] -= 1
    digits.shift if digits[0][1] == 0
    i += 1
  else
    (gaps.first[0]...gaps.first[1]).each do |j|
      a += digits[-1][0] * j
      digits[-1][1] -= 1
      digits.pop if digits[-1][1] == 0
    end
    i = gaps.first.last
    gaps.shift
  end
  break if digits.empty?
end

# Part 2
digits = []
gaps = []

j = 0
input.split('').each_with_index do |digit, i|
  num = digit.to_i
  next if num.zero?

  if i % 2 == 0
    digits << [i / 2, j, j + num]
    j += num
  else
    gaps << [num, j, j + num]
    j += num
  end
end

digits.reverse.each do |digit|
  _, m, n = digit
  len = n - m
  i = gaps.index { |g| g[0] >= len && g[1] < m }
  next if i.nil?

  digit[1] = gaps[i][1]
  digit[2] = gaps[i][1] + len
  if len == gaps[i][0]
    gaps.delete_at(i)
    next
  end
  gaps[i][0] -= len
  gaps[i][1] += len
end

b = 0
digits.each do |digit|
  id, m, n = digit

  (m...n).each { |i| b += id * i }
end

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
