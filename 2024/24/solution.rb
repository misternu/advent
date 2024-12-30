require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
input = helper.send(:open_file, 'input.txt').read
sample_input = helper.send(:open_file, 'sample_input.txt').read
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input
vals, wires = input.split("\n\n")

vals = vals.split("\n").map { |l| l.split(": ") }
wires = wires.split("\n").map do |l|
  m, n = l.split(" -> ")
  m = m.split(" ")
  m + [n]
end

# Part 1

mem = {}
vals.each do |k, v|
  mem[k] = v.to_i
end

wire_proc = wires.map do |m, op, n, out|
  case op
  when "AND"
    [[m, n], proc { |mem| mem[out] = mem[m] & mem[n] }]
  when "XOR"
    [[m, n], proc { |mem| mem[out] = mem[m] ^ mem[n] }]
  when "OR"
    [[m, n], proc { |mem| mem[out] = mem[m] | mem[n] }]
  end
end

until wire_proc.empty?
  keys, prok = wire_proc.shift
  if keys.all? { |k| mem.include?(k) }
    prok.call(mem)
  else
    wire_proc << [keys, prok]
  end
end

a = mem.keys.select { |k| k[0] == 'z' }.sort.reverse.map { |k| mem[k].to_s }.join.to_i(2)

# Part 2
b = nil

swaps = [['grf', 'wpq'], ['fvw', 'z18'], ['z22', 'mdb'], ['nwq', 'z36']]
swap_dict = {}
swaps.each do |m, n|
  swap_dict[m] = n
  swap_dict[n] = m
end

wires = wires.map do |m, op, n, out|
  [m, op, n, swap_dict[out] || out]
end

first_rows = []

(0..44).each do |n|
  vals = ["x#{n.to_s.rjust(2, '0')}", "y#{n.to_s.rjust(2, '0')}"]
  xor = wires.find { |m, op, n, out| op == 'XOR' && [m, n].sort == vals }
  first_rows << xor
end

first_adder = { xor_input: first_rows.shift }
first_adder[:carry] = wires.find { |m, op, n, out| op == 'AND' && [m, n].sort == ['x00', 'y00'] }

full_adders = [first_adder]
first_rows.each_with_index do |xor, i|
  adder = { xor_input: xor }
  output_wire = "z#{(i+1).to_s.rjust(2, '0')}"
  output_xor = wires.find { |m, op, n, out| op == 'XOR' && out == output_wire }
  if output_xor.nil?
    puts "no xor output for #{output_wire}"
    p full_adders.last[:carry]
    p wires.select { |m, op, n, out| out == output_wire }
    p wires.select { |m, op, n, out| [m, n].sort == [xor.last, full_adders.last[:carry].last].sort }
    break
  end
  m, n = output_xor[0], output_xor[2]
  if ![m, n].include?(xor.last) && ![m, n].include?(full_adders.last[:carry].last)
    puts "digit #{i+1} failed, bad output xor, (#{xor.last}, #{output_xor.last})"
    p output_xor
    break
  end
  carry_and_a = wires.select { |m, op, n, out| op == "AND" && [m, n].sort == [xor[0], xor[2]].sort }
  carry_and_b = wires.select do |m, op, n, out|
    op == "AND" && [m, n].sort == [full_adders.last[:carry].last, xor.last].sort
  end
  if carry_and_a.empty?
    puts "digit #{i+1} failed, bad carry and A"
    p [xor[0], xor[2]]
    p carry_and_a
    break
  end
  if carry_and_b.empty?
    puts "digit #{i+1} failed, bad carry and B"
    p [full_adders.last[:carry].last, xor.last]
    p wires.select { |m, op, n, out| op == "AND" && ([m, n].include?(xor.last) || [m, n].include?(full_adders.last[:carry].last))  }
    break
  end
  carry = wires.find { |m, op, n, out| op == "OR" && [m, n].sort == [carry_and_a.last.last, carry_and_b.last.last].sort }
  if carry.nil?
    puts "digit #{i+1} failed, bad carry output"
    p wires.select { |m, op, n, out| [m, n].include?(carry_and_a.last.last) }
    p wires.select { |m, op, n, out| [m, n].include?(carry_and_b.last.last) }
    break
  end
  adder[:carry] = carry
  full_adders << adder
end

# full_adders.each { |adder| p adder }
b = swaps.flatten.sort.join(',')

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
