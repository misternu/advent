require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
input = helper.auto_parse
sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

# Part 1
def evolve(secret)
  result = secret.dup
  result = ((result * 64) ^ result) % 16777216
  result = ((result / 32) ^ result) % 16777216
  ((result * 2048) ^ result) % 16777216
end

a = 0
input.each do |number|
  secret = number.dup
  2000.times { secret = evolve(secret) }
  a += secret
end

# Part 2
charts = input.map do |number|
  secret = number.dup
  result = [secret]

  2000.times do
    result << evolve(result.last)
  end

  result
end

charts = charts.map do |sequence|
  result = { prices: [], changes: [] }

  sequence.each do |number|
    new_price = number % 10
    change = new_price - result[:prices].last unless result[:prices].empty?
    result[:changes] << change unless result[:prices].empty?
    result[:prices] << new_price
  end

  result
end

sequences = Hash.new { |h, k| h[k] = Array.new(charts.length) }

charts.each_with_index do |chart, i|
  chart[:changes].each_cons(4).each_with_index do |cons, j|
    sequences[cons][i] = chart[:prices][j + 4] if sequences[cons][i].nil?
  end
end

b = sequences.values.map { |sales| sales.compact.sum }.max

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
