require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# input = helper.line_separated_strings('input.txt')
input = helper.auto_parse
# MemoryProfiler.start(allow_files: __FILE__)


# Part 1
a = input.dup

# Part 2
b = nil


# MemoryProfiler.stop.pretty_print

helper.output(a, b)
