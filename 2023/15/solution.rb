require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__, counter: false)
input = helper.send(:open_file, 'input.txt').read
sample_input = helper.send(:open_file, 'sample_input.txt').read
# input = helper.line_separated_strings('input.txt')
# sample_input = helper.line_separated_strings('sample_input.txt')
# input = helper.auto_parse
# sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

# Part 1
input = input.strip.split(',')

def hash_for(string)
  string.each_byte.reduce(0) do |acc, byte|
    (acc + byte) * 17 % 256
  end
end

a = input.sum do |l|
  hash_for(l)
end

# Part 2

boxes = Hash.new { |h,k| h[k] = [] } 

input.each do |string|
  label = /\w+/.match(string)[0]
  operation = string.include?("-") ? "-" : "="
  if operation == "="
    number = /\d+/.match(string)[0].to_i
  end

  h = hash_for(label)
  if operation == "-"
    boxes[h] = boxes[h].reject { |l, _| l == label }
  else
    if boxes[h].any? { |l, v| l == label }
      boxes[h] = boxes[h].map do |l, v|
        l == label ? [l, number] : [l, v]
      end
    else
      boxes[h] << [label, number]
    end
  end
end

b = boxes.sum do |k, v|
  v.each_with_index.sum do |lv, i|
    (k + 1) * (i + 1) * lv[1]
  end
end




# MemoryProfiler.stop.pretty_print
helper.output(a, b)
