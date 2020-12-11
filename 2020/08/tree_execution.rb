require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__, clear: false)
input = helper.line_separated_strings('input.txt')
input.map! { |line| line.split(' ') }

class AssemblyTick
  attr_reader :program, :state, :operations
  def initialize(program,
                 options = {},
                 state = {
                   pos: 0,
                   acc: 0,
                   visited: Hash.new,
                   branched: false
                 })
    @program = program
    @state = state
    @operations = options.fetch(:operations, {})
  end

  def tick
    evaluate.map do |operation|
      output = operation.call(arguments)
      state.merge(output)
        .merge(visited: state[:visited].merge({state[:pos] => true}))
    end
  end

  def evaluate
    op = program[state[:pos]].first
    if !state[:branched] && /(jmp|nop)/ =~ op
      other_op = op == 'jmp' ? 'nop' : 'jmp'
      other_lambda = operations[other_op]
      return [
        operations[op],
        lambda { |o| other_lambda.call(o).merge({branched: true}) }
      ]
    end
    [operations[op]]
  end

  def arguments
    {
      pos: state[:pos],
      acc: state[:acc],
      num: program[state[:pos]].last.to_i
    }
  end
end

options = {
  operations: {
    'acc' => lambda { |o| { acc: o[:acc] + o[:num], pos: o[:pos] + 1 } },
    'jmp' => lambda { |o| { pos: o[:pos] + o[:num] } },
    'nop' => lambda { |o| { pos: o[:pos] + 1 } }
  }
}

queue = AssemblyTick.new(input, options).tick
while queue.length > 0
  state = queue.shift
  next if state[:visited][state[:pos]]
  if state[:pos] == input.length
    p state[:acc]
    break
  end
  new_state = AssemblyTick.new(input, options, state).tick
  queue += new_state
end
