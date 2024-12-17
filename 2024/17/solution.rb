require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input
ra = input.first.match(/(\d+)/)[0].to_i
rb = 0
rc = 0
program = input.last.split(' ').last.split(',').map(&:to_i)

# Part 1
output = []
i = 0

def get_combo(arg, ra, rb, rc)
  return arg if arg < 4
  return ra if arg == 4
  return rb if arg == 5
  return rc if arg == 6
end

loop do
  op, arg = program[i..i+1]
  # p [op, arg]

  if ![0, 1, 2, 4, 5, 7, 3].include?(op)
    puts "#{op} not implemented"
    break
  end

  # adv
  if op == 0
    num = ra
    den = 2**get_combo(arg, ra, rb, rc)
    ra = num / den
  end

  # bxl
  if op == 1
    rb = rb ^ arg
  end

  # bst
  if op == 2
    rb = get_combo(arg, ra, rb, rc) % 8
  end

  # bxc
  if op == 4
    rb = rb ^ rc
  end

  # out
  if op == 5
    output << get_combo(arg, ra, rb, rc) % 8
  end

  # cdv
  if op == 7
    num = ra
    den = 2**get_combo(arg, ra, rb, rc)
    rc = num / den
  end

  # jnz
  if op == 3 && ra != 0
    i = arg
  else
    i += 2
  end

  # p [ra, rb, rc]
  # p output
  # sleep 1
  break if i >= program.length
end

a = output.map(&:to_s).join(',')

# Part 2
b = nil

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
