require_relative 'solver'

file = File.open('input.txt')
instructions = file.map do |line| line.chomp end
solver = Solver.new(instructions, [[nil, nil, "1", nil, nil],
                                   [nil, "2", "3", "4", nil],
                                   ["5", "6", "7", "8", "9"],
                                   [nil, "A", "B", "C", nil],
                                   [nil, nil, "D", nil, nil]])
p solver.solve