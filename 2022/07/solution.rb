require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)


input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')

# input = sample_input

input = input.map { |l| l.split(" ") }

# Part 1
file_structure = { files: {} }
wd = []
input.each do |line|
  if line.first == "$"
    if line[1] == "cd"
      path = line.last
      if path == "/"
        wd = []
      elsif path == ".."
        wd.pop
      else
        wd << path
      end
    elsif line[1] == "ls"
      # noop
    else
      p "ERROR"
    end
  else
    current = file_structure
    wd.each do |d|
      current = current[d]
    end
    if line[0] == "dir"
      current[line[1]] = { files: {} }
    else
      current[:files][line[1]] = line[0].to_i
    end
  end
end

def recursive_size_1(files, top = false, memo = { s: 0 })
  keys = files.keys - [:files]
  size = keys.sum { |k| recursive_size_1(files[k], false, memo) }
  size += files[:files].values.sum
  if size < 100000
    memo[:s] += size
  end
  if top
    return memo[:s]
  else
    return size
  end
end

# a = nil
a = recursive_size_1(file_structure, true)

# Part 2
def recursive_size_2(files, top = false, memo = [])
  keys = files.keys - [:files]
  size = keys.sum { |k| recursive_size_2(files[k], false, memo) }
  size += files[:files].values.sum
  memo << size
  if top
    return memo
  else
    return size
  end
end
sizes = recursive_size_2(file_structure, true)
total = sizes.max
needed = 30000000 - (70000000 - total)

b = sizes.sort.find { |v| v >= needed } 


# MemoryProfiler.stop.pretty_print
helper.output(a, b)
