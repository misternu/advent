require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
# MemoryProfiler.start(allow_files: __FILE__)


input = helper.send(:open_file, 'input.txt').read
sample_input = helper.send(:open_file, 'sample_input.txt').read

# input = sample_input

input = input.split("\n\n")
input.map! do |monkey|
  lines = monkey.split("\n")
  items = lines[1].scan(/\d+/).map(&:to_i)
  operation_line = lines[2].split(" ")
  operation = [operation_line[-2], operation_line[-1]]
  test_value = lines[3].scan(/\d+/).last.to_i
  if_true = lines[4].scan(/\d+/).last.to_i
  if_false = lines[5].scan(/\d+/).last.to_i

  { items: items, op: operation, tst: test_value, t: if_true, f: if_false }
end

class Runner
  attr_accessor :count, :items, :operations, :modulos, :forks, :inspections
  def initialize(monkeys, divide = false)
    @count = monkeys.length
    @items = Hash.new { |h, k| h[k] = [] }
    @operations = []
    @modulos = []
    @forks = []
    @inspections = Hash.new(0)
    monkeys.each_with_index do |monkey, i|
      monkey[:items].each do |v|
        @items[i] << v
      end
      @operations << lambda_for(monkey[:op])
      @modulos << monkey[:tst]
      @forks << { t: monkey[:t], f: monkey[:f] }
    end
    @items.keys.each do |key|
      @items[key].map! do |v|
        @modulos.map { |m| v % m }
      end
    end
  end

  def run(reps = 1)
    reps.times do
      (0...count).each do |i|
        inspections[i] += items[i].length
        op = operations[i]
        items[i].each do |item|
          new_values = item.zip(modulos).map do |v, m|
            op.call(v, m)
          end
          if new_values[i] == 0
            items[forks[i][:t]] << new_values
          else
            items[forks[i][:f]] << new_values
          end
        end
        items[i] = []
      end
    end
    inspections
  end

  private

  def lambda_for(op)
    if op.last == "old"
      return lambda { |n, m| (n * n) % m }
    end
    num = op.last.to_i
    if op.first == "+"
      return lambda { |n, m| (n + (num % m)) % m }
    else
      return lambda { |n, m| (n * (num % m)) % m }
    end
  end
end

# Part 1
# deleted code, part 2 incompatible with part one
a = nil

# Part 2
runner = Runner.new(input)
inspections = runner.run(10000)
b = inspections.values.max(2).reduce(&:*)


# MemoryProfiler.stop.pretty_print
helper.output(a, b)
