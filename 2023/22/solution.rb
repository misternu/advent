require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# input = helper.line_separated_strings('input.txt')
# sample_input = helper.line_separated_strings('sample_input.txt')
input = helper.auto_parse
sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

input = sample_input

# Part 1
input = input.map { |r| r.map(&:to_i) }



a = nil

# Part 2
b = nil



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
