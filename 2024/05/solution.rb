require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
input = helper.send(:open_file, 'input.txt').read
sample_input = helper.send(:open_file, 'sample_input.txt').read
# input = helper.line_separated_strings('input.txt')
# input = helper.comma_separated_strings('input.txt')
# input = helper.auto_parse
# sample_input = helper.line_separated_strings('sample_input.txt')
# sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

pairs, lists = input.split("\n\n")
rules = pairs.split("\n").map { |l| l.split("|").map(&:to_i) }
lists = lists.split("\n").map { |l| l.split(",").map(&:to_i) }

# Part 1
a = 0

def correct?(list, rules)
  rules.each do |a, b|
    a_pos = list.index(a)
    b_pos = list.index(b)
    next if a_pos.nil? || b_pos.nil?
    return 0 unless a_pos < b_pos
  end
  list[list.length / 2]
end

lists.each do |list|
  a += correct?(list, rules)
end

# Part 2
def fix_list(list, rules)
  new_list = list.dup
  while correct?(new_list, rules).zero?
    rules.each do |a, b|
      m = new_list.index(a)
      n = new_list.index(b)
      new_list.insert(m, new_list.delete_at(n)) unless m.nil? || n.nil? || m < n
    end
  end
  new_list[new_list.length / 2]
end

b = 0

lists.each do |list|
  b += fix_list(list, rules) if correct?(list, rules).zero?
end

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
