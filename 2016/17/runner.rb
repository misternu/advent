require_relative 'state'

input = 'hhhxzeay'
start = State.new({input: input})

queue = [start]
valids = []

until queue.empty?
  current = queue.shift
  queue += current.move_states
  valids << current if current.done?
end

p valids.first.moves.join
p valids.max_by { |state| state.moves.length }.moves.length