require_relative '../../lib/advent_helper'

helper = AdventHelper.new(script_root:__dir__)

input = helper.line_separated_strings('input.txt')

reactions = Hash.new
input.each do |reaction|
  ingredients, output = reaction.split('=>').map(&:strip)
  output = output.split(' ').tap { |o| o[0] = o[0].to_i}
  ingredients = ingredients.split(', ').map { |i| i.split(' ') }.map { |i| [i[0].to_i, i[1]] }
  reactions[output] = ingredients
end

def ore_need(reactions, n)
  needs = Hash.new(0)
  needs["FUEL"] = n
  until needs.all? { |k, v| k == "ORE" || v <= 0 }
    key = needs.find { |k, v| k != "ORE"  && v > 0 }.first
    reaction = reactions.keys.find { |n, i| n > 0 && i == key }
    times = (needs[key].to_f / reaction.first).ceil 
    reactions[reaction].each { |i| needs[i.last] += i.first * times }
    needs[reaction.last] -= reaction.first * times
  end
  needs["ORE"]
end

# Part 1
p ore_need(reactions, 1)

# Part 2
p (0..10000000).bsearch { |n| ore_need(reactions, n) > 1000000000000 } - 1
