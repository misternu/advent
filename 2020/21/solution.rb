require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# responses = input.split("\n\n").map { |r| r.split(/\s+/).map(&:chars) }
# input = helper.auto_parse
# input = helper.auto_parse('sample_input.txt')
input = helper.line_separated_strings('input.txt')
# input = helper.line_separated_strings('sample_input.txt')



# Part 1
counts = Hash.new(0)
potential_sources = Hash.new

input.each do |line|
  ingredients, allergens = line.split("(")
  ingredients = ingredients.split(/\W+/)
  allergens = allergens.split(/\W+/)
  allergens.delete("contains")
  ingredients.each do |i|
    counts[i] += 1
  end
  allergens.each do |a|
    potential_sources[a] ||= ingredients
    potential_sources[a] = potential_sources[a] & ingredients
  end
end

all_potential_sources = potential_sources.values.flatten.uniq
no_allergens = counts.keys.select { |ingredient| !all_potential_sources.include?(ingredient) }
a = counts.select { |k, v| no_allergens.include?(k) } .values.sum

# Part 2
definite = Hash.new
while potential_sources.values.flatten.length > 0
  aller, sources = potential_sources.find { |k, v| v.length == 1 }
  definite[sources.first] = aller
  potential_sources.delete(aller)
  potential_sources.keys.each do |k|
    potential_sources[k].delete(sources.first)
  end
end
b = definite.sort_by { |k, v| v }.map(&:first).join(",")



helper.output(a, b)
