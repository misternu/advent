require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__, counter: false)
# input = helper.send(:open_file, 'input.txt').read
# input = helper.line_separated_strings('input.txt')
# sample_input = helper.line_separated_strings('sample_input.txt')
input = helper.auto_parse
sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)


# input = sample_input

# Part 1
instr = input.first.first.chars
forks = input[2..-1]
map = {}
forks.each do |a, b, c|
  map[a] = [b, c]
end

pos = "AAA"
i = 0
until pos == "ZZZ"
  fork = map[pos]
  pos = instr[i % instr.length] == "R" ? fork[1] : fork[0]
  i += 1
end

a = i

# Part 2
# input = sample_input
instr = input.first.first.chars
forks = input[2..-1]
map = {}
forks.each do |a, b, c|
  map[a] = [b, c]
end

pos = map.keys.filter { |k| /..A/ =~ k }
i = 0

repeater = {}
until repeater.values.length == pos.length && repeater.values.all? { |v| v.class == Integer }
  forks = pos.map { |k| map[k] }
  j = instr[i % instr.length] == "R" ? 1 : 0
  pos = forks.map { |v| v[j] }
  i += 1
  if pos.any? { |v| /..Z/ =~ v }
    indices = (0...pos.length).filter { |v| /..Z/ =~ pos[v] }
    indices.each do |k|
      if repeater[k] && repeater[k].class == Array && repeater[k].first == pos[k]
        repeater[k] = i - repeater[k].last
      end
      if repeater[k] == nil
        repeater[k] = [pos[k], i]
      end
    end
  end
end

b = repeater.values.reduce(&:lcm)



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
