require_relative '../../lib/advent_helper'
require_relative 'intcode_computer'

helper = AdventHelper.new(script_root:__dir__)

program = helper.comma_separated_strings('input.txt').map(&:to_i)

# Part 1
max = 0
(0..4).to_a.permutation.each do |phases|
  computer = IntcodeComputer.new(program, IntcodeIO.new([phases[0], 0]))
  output = computer.run[0]
  next unless output
  computer = IntcodeComputer.new(program, IntcodeIO.new([phases[1], output]))
  output = computer.run[0]
  next unless output
  computer = IntcodeComputer.new(program, IntcodeIO.new([phases[2], output]))
  output = computer.run[0]
  next unless output
  computer = IntcodeComputer.new(program, IntcodeIO.new([phases[3], output]))
  output = computer.run[0]
  next unless output
  computer = IntcodeComputer.new(program, IntcodeIO.new([phases[4], output]))
  output = computer.run[0]
  next unless output
  max = [output, max].max
end
p max

# Part 2

best = 0
(5..9).to_a.permutation.each do |phases|
# [[9,7,8,5,6]].each do |phases|
  computers = (0..4).map do |i|
    IntcodeComputer.new(program, IntcodeIO.new([phases[i]]), wait: true)
  end
  running = true
  last_signal = 0
  while running
    computers.first.io.add(last_signal)
    computers[0].waiting = false
    computers[0].run
    # p computers[0]
    output = computers[0].io.shift
    unless output
      running = false
      next
    end

    computers[1].io.add(output)
    computers[1].waiting = false
    computers[1].run
    # p computers[1]
    output = computers[1].io.shift
    unless output
      running = false
      next
    end

    computers[2].io.add(output)
    computers[2].waiting = false
    computers[2].run
    # p computers[2]
    output = computers[2].io.shift
    unless output
      running = false
      next
    end

    computers[3].io.add(output)
    computers[3].waiting = false
    computers[3].run
    # p computers[3]
    output = computers[3].io.shift
    unless output
      running = false
      next
    end

    computers[4].io.add(output)
    computers[4].waiting = false
    computers[4].run
    # p computers[4]
    output = computers[4].io.shift
    unless output
      running = false
      next
    end

    last_signal = output

    if computers.any? { |c| c.stopped }
      break
    end
  end
  if last_signal
    best = [last_signal, best].max
  end
end
p best
