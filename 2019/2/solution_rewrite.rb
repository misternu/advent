class IntcodeComputer
  def initialize(memory, options = {})
    @memory = memory.dup
    @address = options.fetch(options[:address], 0)
    @noun = options.fetch(:noun, 0)
    @verb = options.fetch(:verb, 0)
    @memory[1] = @noun
    @memory[2] = @verb
  end

  def run
    if operate[1]
      step
      run
    else
      halt
    end
  end

  def operate
    case opcode
    when 1
      [add, true]
    when 2
      [multiply, true]
    when 99
      [nil, false]
    end
  end

  def add
    a, b, c = parameters
    @memory[c] = @memory[a] + @memory[b]
  end

  def multiply
    a, b, c = parameters
    @memory[c] = @memory[a] * @memory[b]
  end

  def opcode
    @memory[@address]
  end

  def parameters
    if [1, 2].include?(opcode)
      get(3)
    else
      get(0)
    end
  end

  def get(number)
    return [] if number < 1
    (1..number).map do |i|
      @memory[@address + i]
    end
  end

  def step
    if [1, 2].include?(opcode)
      @address += 4
    end
  end

  def halt
    @memory[0..3]
  end
end

require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
input = helper.comma_separated_strings('input.txt').map(&:to_i)

# Part 1
computer = IntcodeComputer.new(input, noun: 12, verb: 2)
p computer.run[0]

# Part 2
target = 19690720
(0..99).each do |noun|
  found = false
  (0..99).each do |verb|
    computer = IntcodeComputer.new(input, noun: noun, verb: verb)
    output = computer.run[0]
    if output == target
      p 100 * noun + verb
      found = true
      break
    end
  end
  if found
    break
  end
end
