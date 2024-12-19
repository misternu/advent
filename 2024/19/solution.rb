require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
input = helper.send(:open_file, 'input.txt').read
sample_input = helper.send(:open_file, 'sample_input.txt').read
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

patterns, designs = input.split("\n\n")
patterns = patterns.split(", ")
designs = designs.chomp.split("\n")

# Part 1
a = 0

def search(design, patterns, i = 0, memo = {})
  return false if memo[i]

  options = patterns.select { |x| x == design[i...i + x.length] }
  options = options.map(&:length)
  options = options.reject { |x| memo[i + x] }

  if options.empty?
    memo[i] = true
    return false
  end

  return true if options.any? { |x| i + x == design.length }

  options.each do |x|
    return true if search(design, patterns, i + x, memo)
    memo[x] = true
  end

  memo[i] = true
  false
end

designs.each do |design|
  a += 1 if search(design, patterns)
end

# Part 2

def search_count(design, patterns, i = 0, memo = {})
  return memo[i] if memo.keys.include?(i)

  options = patterns.select { |x| x == design[i...i + x.length] }
  options = options.map(&:length)

  c = 0
  options.each do |x|
    if i + x == design.length
      c += 1
    else
      c += search_count(design, patterns, i + x, memo)
    end
  end
  memo[i] = c
  return c
end

b = 0

designs.each do |design|
  b += search_count(design, patterns)
end

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
