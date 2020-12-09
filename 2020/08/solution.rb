require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# responses = input.split("\n\n").map { |r| r.split(/\s+/).map(&:chars) }
# input = helper.auto_parse
input = helper.line_separated_strings('input.txt')
# input = helper.comma_separated_strings('input.txt')


class AssemblyNode
  attr_reader :input, :operations
  attr_accessor :pos, :acc, :log, :visited
  def initialize(input, options = {})
    @input = input
    @visited = Hash.new
    @log = []
    @operations = options.fetch(:operations, {})
    @pos = 0
    @acc = 0
  end

  def self.run(input, options = {})
    self.new(input, options).run
  end

  def run
    main_loop
    halt
  end

  def main_loop
    return if halt_condition
    logging
    tick
    main_loop
  end

  def tick
    operation = evaluate
    output = operation.call(arguments)
    persist(output)
  end

  def evaluate
    operations[input[pos].split(' ').first]
  end

  def arguments
    {
      pos: pos,
      acc: acc,
      num: input[pos].split(' ').last.to_i
    }
  end

  def persist(output)
    self.acc = output[:acc] if output[:acc]
    self.pos = output[:pos] if output[:pos]
  end

  def logging
    visited[pos] = true
    log << input[pos].dup
  end

  def halt_condition
    visited[pos] || pos >= input.length
  end

  def halt
    acc
  end

  def print_logs
    puts log
  end
end

# Part 1
options = {
  operations: {
    'acc' => lambda { |o| { acc: o[:acc] + o[:num], pos: o[:pos] + 1 } },
    'jmp' => lambda { |o| { pos: o[:pos] + o[:num] } },
    'nop' => lambda { |o| { pos: o[:pos] + 1 } }
  }
}

a = AssemblyNode.run(input, options)

# Part 2
b = nil
(0...input.length).each do |i|
  instrs = input.dup
  op, num = instrs[i].split(' ')
  next if op == 'acc'
  op = op == 'nop' ? 'jmp' : 'nop'
  instrs[i] = [op, num].join(' ')

  node = AssemblyNode.new(instrs, options)
  output = node.run

  if node.pos == instrs.length
    b = output
    break
  end
end



helper.output(a, b)
