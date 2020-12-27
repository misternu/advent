require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__, script_file: __FILE__)
input = helper.auto_parse


def solve(key)
  count = 0
  memo = 1
  while true
    return count if memo == key
    memo = (memo * 7) % 20201227
    count += 1
  end
end

def encryption(subject, loop_size)
  (subject ** loop_size) % 20201227
end

def encryption_larger_loop_size(subject, loop_size)
  (1..loop_size).reduce(1) { |memo, l| memo * subject % 20201227 }
end

card_public, door_public = input

card_loops = solve(card_public)
door_loops = solve(door_public)

a = [encryption(door_public, card_loops), encryption_larger_loop_size(card_public, door_loops)]
b = nil


helper.output(a, b)
