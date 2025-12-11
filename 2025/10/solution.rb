require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
# input = helper.send(:open_file, 'input.txt').read
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

class MachineOne
  def initialize(goal, buttons, joltage)
    @goal = goal
    @buttons = buttons
    @joltage = joltage
    @from = {}
  end

  def neighbors(pos)
    candidates = @buttons.map do |button|
      pos.map.with_index do |v, i|
        button.include?(i) ? !v : v
      end
    end
    candidates.reject { |v| @from.keys.include?(v) }
  end

  def solve
    search
    count
  end

  def search
    p @goal
    empty = Array.new(@goal.length) { false }

    queue = [empty]

    until queue.empty?
      pos = queue.shift

      neighbors(pos).each do |n|
        @from[n] = pos
        queue << n
      end
    end
  end

  def count
    count = 0
    pos = @goal
    until pos.none?
      pos = @from[pos]
      count += 1
    end
    count
  end
end

class MachineTwo < MachineOne
  def neighbors(pos)
    candidates = @buttons.map do |button|
      pos.map.with_index do |v, i|
        button.include?(i) ? v + 1 : v
      end
    end
    candidates.reject! do |candidate|
      (0...@goal.length).any? do |i|
        candidate[i] > @joltage[i]
      end
    end
    candidates.reject { |v| @from.key?(v) }
  end

  def search
    p @joltage
    empty = Array.new(@goal.length) { 0 }

    queue = [empty]
    until queue.empty?
      pos = queue.shift

      neighbors(pos).each do |n|
        @from[n] = pos
        queue << n
      end
    end
  end

  def count
    count = 0
    pos = @joltage
    until pos.all? { |n| n.zero? }
      pos = @from[pos]
      count += 1
    end
    count
  end
end

machines = []

input.each do |l|
  config = l.split(' ')
  goal = config.shift.chars[1...-1].map { |c| c == '#' }
  buttons = config[0...-1].map { |c| c[1..-1].split(',').map(&:to_i) }
  joltage = config.last[1..-1].split(',').map(&:to_i)
  machines << MachineOne.new(goal, buttons, joltage)
end

# Part 1

a = machines.sum(&:solve)

# Part 2
machines = []
input.each do |l|
  config = l.split(' ')
  goal = config.shift.chars[1...-1].map { |c| c == '#' }
  buttons = config[0...-1].map { |c| c[1..-1].split(',').map(&:to_i) }
  joltage = config.last[1..-1].split(',').map(&:to_i)
  machines << MachineTwo.new(goal, buttons, joltage)
end
b = machines.sum(&:solve)

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
