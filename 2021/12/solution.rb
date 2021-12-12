require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# input = helper.auto_parse
# sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)
# input = sample_input


neighbors = Hash.new { |h, k| h[k] = [] }
input.each do |line|
  a, b = line.split('-')
  neighbors[a] << b
  neighbors[b] << a
end
# Part 1
paths = [["start"]]
complete_paths = []
while paths.any?
  path = paths.shift
  if path.last == 'end'
    complete_paths << path
    next
  end
  current_location = path.last
  choices = neighbors[current_location].select { |l| /[[:upper:]]/.match(l) || !path.include?(l) }
  new_paths = choices.map do |choice|
    path + [choice]
  end
  paths += new_paths
end

a = complete_paths.count

# Part 2
paths = [["start"]]
complete_paths = []
def can_go(path, location)
  return false if location == 'start'
  return true if /[[:upper:]]/.match(location)
  locs = path.tally
  lowercase_locs = locs.keys.select { |k| k != 'start' && /[[:lower:]]/.match(k) }
  return true if lowercase_locs.all? { |l| locs[l] < 2 }
  return true if !path.include?(location)
  false
end
while paths.any?
  path = paths.shift
  if path.last == 'end'
    complete_paths << path
    next
  end
  current_location = path.last
  choices = neighbors[current_location].select { |l| can_go(path, l) }
  new_paths = choices.map do |choice|
    path + [choice]
  end
  paths += new_paths
end
b = complete_paths.count



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
