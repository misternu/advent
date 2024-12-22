require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
input = helper.auto_parse
sample_input = helper.auto_parse('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

NUMPAD = [
  ['7', '8', '9'],
  ['4', '5', '6'],
  ['1', '2', '3'],
  [' ', '0', 'A']
].freeze
NUMPAD_START = [3, 2].freeze # y, x

DIRPAD = [
  [' ', '^', 'A'],
  ['<', 'v', '>']
].freeze
DIRPAD_START = [0, 2].freeze # y, x

DIRS = [[0, -1], [1, 0], [0, 1], [-1, 0]].freeze
DIR_STRING = ['^', '>', 'v', '<'].freeze

# Part 1

def pad_inputs(string, pad, pad_start)
  inputs = []
  queue = [[pad_start.dup, '', 0]]
  until queue.empty?
    pos, output, i = queue.shift
    next if pad.dig(*pos) == ' '

    goal = string[i]

    if pad.dig(*pos) == goal
      if i + 1 == string.length
        inputs << "#{output}A"
      else
        queue << [pos, "#{output}A", i + 1]
      end
    end

    goal_loc = nil
    pad_height = pad.length
    pad_width = pad.first.length
    (0...pad_height).each do |y|
      (0...pad_width).each do |x|
        goal_loc = [y, x] if pad.dig(y, x) == goal
      end
    end

    choices = []
    choices << '^' if goal_loc[0] < pos[0]
    choices << 'v' if goal_loc[0] > pos[0]
    choices << '<' if goal_loc[1] < pos[1]
    choices << '>' if goal_loc[1] > pos[1]

    choices.each do |choice|
      choice_dir = DIRS[DIR_STRING.index(choice)]
      dx, dy = choice_dir
      queue << [[pos[0] + dy, pos[1] + dx], output + choice, i]
    end
  end
  inputs.uniq
end

def numpad_inputs(string, start = NUMPAD_START)
  pad_inputs(string, NUMPAD, start)
end

def dirpad_inputs(string, start = DIRPAD_START)
  pad_inputs(string, DIRPAD, start)
end

def get_pos(char, pad)
  pad_height = pad.length
  pad_width = pad.first.length
  (0...pad_height).each do |y|
    (0...pad_width).each do |x|
      return [y, x] if pad.dig(y, x) == char
    end
  end
end

def dirpad_dig(string, depth, memo)
  return memo[[string, depth]] if memo[[string, depth]]

  if depth == 1
    min_cost = dirpad_inputs(string).map(&:length).min
    memo[[string, depth]] = min_cost
    return min_cost
  end

  pos = DIRPAD_START
  cost = 0
  string.chars.each do |char|
    choices = dirpad_inputs(char, pos)
    char_costs = choices.map { |choice| dirpad_dig(choice, depth - 1, memo) }
    cost += char_costs.min
    pos = get_pos(char, DIRPAD)
  end
  memo[[string, depth]] = cost
  cost
end

a = 0
dirpad_memo = {}
input.each do |line|
  pos = NUMPAD_START
  total = 0
  line.chars.each do |char|
    choices = numpad_inputs(char, pos)
    costs = choices.map do |choice|
      dirpad_dig(choice, 2, dirpad_memo)
    end
    total += costs.min
    pos = get_pos(char, NUMPAD)
  end
  a += total * line[0..2].to_i
end

# Part 2
b = 0
dirpad_memo = {}
input.each do |line|
  pos = NUMPAD_START
  total = 0
  line.chars.each do |char|
    choices = numpad_inputs(char, pos)
    costs = choices.map do |choice|
      dirpad_dig(choice, 25, dirpad_memo)
    end
    total += costs.min
    pos = get_pos(char, NUMPAD)
  end
  b += total * line[0..2].to_i
end

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
