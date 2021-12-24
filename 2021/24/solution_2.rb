require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)
# input = sample_input

# Part 1
class MonadComputer
  attr_reader :instructions
  def initialize(divide, add_1, add_2)
    @divide = divide
    @add_1 = add_1
    @add_2 = add_2
    process_instructions
  end

  def process_instructions
    @instructions = []
    (0...14).each do |i|
      if @divide[i] == 1 && @add_1[i] > 9
        @instructions << [:push, @add_2[i]]
      else
        @instructions << [:pop, @add_1[i], @add_2[i]]
      end
    end

    @equalities = {}
    i_stack = []
    @instructions.each_with_index do |instr, i|
      if instr[0] == :pop
        j = i_stack.pop
        @equalities[[j, i]] =  Proc.new do |x, y|
          x + @instructions[j][1] + instr[1] == y
        end
      else
        i_stack << i
      end
    end

    @min = {}
    @max = {}
    @equalities.keys.each do |key|
      equality = @equalities[key]
      (1..9).to_a.repeated_permutation(2).each do |x, y|
        if equality.call(x,y)
          @min[key.first] ||= x
          @min[key.last]  ||= y
          @max[key.first]   = x
          @max[key.last]    = y
        end
      end
    end
  end

  def min
    @min.values_at(*(0...14).to_a).map(&:to_s).join.to_i
  end

  def max
    @max.values_at(*(0...14).to_a).map(&:to_s).join.to_i
  end

  # doesn't get used, originally made this to test assumptions
  def run(input_array)
    total = []
    (0...input_array.length).each do |i|
      if @instructions[i].first == :push
        total.push(input_array[i] + @instructions[i].last)
      else
        if total.pop + @instructions[i][1] != input_array[i]
          total.push(input_array[i] + @instructions[i][2])
        end
      end
    end
    total.reduce(0) { |memo, i| memo * 26 + i }
  end
end

divide = []
add_1 = []
add_2 = []
input.each_slice(18) do |slice|
  divide << slice[4].split(' ').last.to_i
  add_1 << slice[5].split(' ').last.to_i
  add_2 << slice[15].split(' ').last.to_i
end
computer = MonadComputer.new(divide, add_1, add_2)

a = computer.max

# Part 2
b = computer.min



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
