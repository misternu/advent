require_relative 'cpu'

instructions = File.open('input.txt').read.split("\n").map(&:split)

initial = 198
registers = Hash.new(0)
registers["a"] = initial
cpu = CPU.new(instructions, {registers: registers})
cpu.execute
p cpu.output
