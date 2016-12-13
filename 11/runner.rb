require 'set'
require_relative 'state'

floors = File.open('input.txt').readlines.map do |floor|
  /nothing/ =~ floor ? [[],[]] :
    [floor.scan(/(\w+) gen/).flatten.sort, floor.scan(/(\w+)-comp/).flatten.sort]
end

state = State.new(floors)

queue = [state]
tried = Set.new(queue)
max_depth = 50
until queue.first.depth > max_depth || queue.first.solved?
  current = queue.shift
  # p current.depth
  string = "#{tried.length} #{current.depth} #{queue.length}\n"
  current.floors.reverse.each do |floor|
    string += "#{floor[0].length} #{floor[1].length}\n"
  end
  puts string
  queue = (queue + current.moves).uniq - tried.to_a
  # queue = queue.sort_by { |move| move.value }.reverse
  tried.merge([current])
end
# p tried.length
if queue.first.solved?
  p queue.first
else
  p "I need mooa pawaaa captain"
end