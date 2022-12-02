require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)

input = helper.send(:open_file, 'input.txt').read

input = input.split("\n").map { |l| l.split(" ") }

values = {
  "A" => :R,
  "B" => :P,
  "C" => :S,
  "X" => :R,
  "Y" => :P,
  "Z" => :S
}

shapes = {
  R: 1,
  P: 2,
  S: 3
}


# Part 1
a = input.sum do |round|
  elf, me = round.map { |v| values[v] }
  win = me == :R && elf == :S ||
        me == :P && elf == :R ||
        me == :S && elf == :P
  draw = me == elf

  points = 0
  points += shapes[me]
  points += 6 if win
  points += 3 if draw
  points
end

# Part 2
values = {
  "A" => :R,
  "B" => :P,
  "C" => :S,
  "X" => :L,
  "Y" => :D,
  "Z" => :W
}
b = input.sum do |round|
  elf, goal = round.map { |v| values[v] }
  points = 0 
  case goal
  when :L
    me = { R: :S, P: :R, S: :P }[elf]
    points += shapes[me]
  when :D
    me = elf
    points += shapes[me]
    points += 3
  when :W
    me = { R: :P, P: :S, S: :R }[elf]
    points += shapes[me]
    points += 6
  end
  points
end


helper.output(a, b)
# 19m43s
