require_relative 'cpu'

instructions = File.open('input.txt').read.split("\n").map(&:split)

cpu = CPU.new(instructions)
p cpu.execute["a"]

modified_hash = Hash.new(0)
modified_hash["c"] = 1
cpu = CPU.new(instructions, {registers: modified_hash})
p cpu.execute["a"]