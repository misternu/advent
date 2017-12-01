require_relative 'cpu'

instructions = File.open('input.txt').read.split("\n").map(&:split)

egg_registers = Hash.new(0)
egg_registers["a"] = 7
cpu = CPU.new(instructions, {registers: egg_registers})
p cpu.execute["a"]

instructions = File.open('input.txt').read.split("\n").map(&:split)

egg_registers = Hash.new(0)
egg_registers["a"] = 12
cpu = CPU.new(instructions, {registers: egg_registers})
p cpu.execute["a"]
