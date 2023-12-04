require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# input = helper.auto_parse
# sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)



# Part 1
a = input.sum do |s|
  split = s.split(":")
  game_num = /\d+/.match(split.first).to_a.last.to_i
  rounds = split.last.strip.split(";").map(&:strip)
  colors = { 'red': 0, 'blue': 0, 'green': 0 }
  rounds.each do |round|
    nums = round.split(", ")
    nums.each do |num|
      n, color = num.split(' ')
      colors[color.to_sym] = [colors[color.to_sym], n.to_i].max
    end
  end
  if colors[:red] <= 12 && colors[:green] <= 13 && colors[:blue] <= 14
    game_num
  else
    0
  end
end

# Part 2
b = input.sum do |s|
  split = s.split(":")
  game_num = /\d+/.match(split.first).to_a.last.to_i
  rounds = split.last.strip.split(";").map(&:strip)
  colors = { 'red': 0, 'blue': 0, 'green': 0 }
  rounds.each do |round|
    nums = round.split(", ")
    nums.each do |num|
      n, color = num.split(' ')
      colors[color.to_sym] = [colors[color.to_sym], n.to_i].max
    end
  end
  colors.values.reduce(&:*)
end



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
