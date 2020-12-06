require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
input = helper.send(:open_file, 'input.txt').read
responses = input.split("\n\n")
responses.map! { |response| response.split(/\s+/) }



# Part 1
a = responses.map do |response|
  response.map { |person| person.split('').uniq }.flatten.uniq.count
end .sum

# Part 2
b = responses.map do |response|
  people = response.map { |person| person.split('').uniq }
  people[1..-1].inject(people.first) { |array, p| array & p } .length
end .sum



helper.output(a, b)
