require_relative 'state'
require 'benchmark'

floors = File.open('input.txt').readlines.map do |floor|
  /nothing/ =~ floor ? [[],[]] :
    [floor.scan(/(\w+) gen/).flatten.sort, floor.scan(/(\w+)-comp/).flatten.sort]
end

types = floors.flatten.uniq

data = types.map do |type|
  [floors.index { |floor| floor.first.include?(type) }, floors.index { |floor| floor.last.include?(type) }]
end .sort.reverse

bottom_count = data.count { |isotope| isotope == [0,0] }

data = data[0..-bottom_count]


# p data

state = State.new(data)

queue = [state]
tried = queue.dup

puts Benchmark.measure {
  until queue.first.done?
    current = queue.shift
    new_moves = current.moves - tried
    tried = (tried + new_moves).uniq
    queue = (queue + new_moves).uniq
    # p current.isotopes
  end
}

# bottom_count += 2
p queue.first.depth  + (bottom_count - 1) * 12