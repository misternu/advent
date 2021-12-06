require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# input = helper.line_separated_strings('input.txt')
input = helper.auto_parse
sample_input = "3,4,3,1,2".split(',').map(&:to_i)


# Part 1
fish = input.dup
80.times do
  fish_spawn = 0
  new_fish = fish.map do |f|
    if f == 0
      fish_spawn += 1
      6
    else
      f - 1
    end
  end
  fish = new_fish + [8] * fish_spawn
end

a = fish.length

# Part 2
fishes = Hash.new(0).merge(input.tally)
256.times do
  fish_spawn = fishes[0]
  new_fishes = Hash.new(0)
  (0..7).each do |n|
    new_fishes[n] = fishes[n+1]
  end
  new_fishes[6] += fish_spawn
  new_fishes[8] = fish_spawn
  fishes = new_fishes
end
b = fishes.values.sum


helper.output(a, b)
