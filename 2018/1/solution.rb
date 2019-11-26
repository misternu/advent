require_relative '../../lib/advent_helper'

helper = AdventHelper.new(script_root:__dir__)

input = helper.line_separated_strings('input.txt').map(&:to_i)

# Part One

p input.sum

# Part Two

known = Hash.new
freq = 0
found = false

until found
  input.each do |change|
    known[freq] = true
    freq += change
    if known[freq]
      puts freq
      found = true
      break
    end
  end
end
