require_relative 'state'

input = 'hhhxzeay'
start = State.new({input: input})

queue = [start]

while queue.first.position != [3,3]
  current = queue.shift
  queue += current.move_states
end

p queue.first.moves.join

queue = [start]
valids = []

until queue.empty?
  current = queue.shift
  if current.position == [3,3]
    valids << current
  else
    queue += current.move_states
  end
end

p valids.max_by { |state| state.moves.length }.moves.length