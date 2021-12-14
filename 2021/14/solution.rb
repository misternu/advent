require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
input = helper.auto_parse
sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)
# input = sample_input
word = input.first.first
lexicon = input[2..-1].to_h



# Part 1
word_a = word.dup
10.times do
  insertion_points = (0...word_a.length-1).select do |i|
    lexicon[word_a[i,2]]
  end
  insertion_points.reverse.each do |i|
    word_a.insert(i+1, lexicon[word_a[i,2]])
  end
end
tally = word_a.split('').tally
min, max = tally.values.min, tally.values.max
part_1 = max - min



# Part 2
def r_tally(lexicon, a, b, depth, memo)
  key = [a, b, depth]
  return memo[key] if memo.has_key?(key)
  if depth == 0
    if a == b
      memo[key] = { a => 2 }
    else
      memo[key] = { a => 1, b => 1 }
    end
    return memo[key]
  end
  c = lexicon[[a, b].join]
  if c
    a_tally = r_tally(lexicon, a, c, depth - 1, memo)
    b_tally = r_tally(lexicon, c, b, depth - 1, memo)
    total = Hash.new(0)
    a_tally.each { |k, v| total[k] += v }
    b_tally.each { |k, v| total[k] += v }
    total[c] -= 1
    memo[key] = total
    memo[key]
  else
    memo[key] = { a => 1, b => 1 }
    memo[key]
  end
end

word_b = word.dup
tally = Hash.new(0)
memo = Hash.new

(0...word_b.length-1).each do |i|
  a, b = word_b[i,2].split('')
  pair_tally = r_tally(lexicon, a, b, 40, memo)
  pair_tally.each { |k, v| tally[k] += v }
end

# remove extras from overlapping pairs
(1...word_b.length-1).each do |i|
  tally[word_b[i]] -= 1 
end

max = tally.values.max
min = tally.values.min
part_2 = max - min



# MemoryProfiler.stop.pretty_print
helper.output(part_1, part_2)
