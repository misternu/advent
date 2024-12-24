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
    [[m, n], Proc.new { |mem| mem[out] = mem[m] & mem[n] }]
  when "XOR"
    [[m, n], Proc.new { |mem| mem[out] = mem[m] ^ mem[n] }]
  when "OR"
    [[m, n], Proc.new { |mem| mem[out] = mem[m] | mem[n] }]
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

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
