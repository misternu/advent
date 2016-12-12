class CPU
  attr_reader :instructions, :registers, :line
  def initialize(instructions, options = {})
    @instructions = instructions
    @registers = options.fetch(:registers, Hash.new(0))
    @line = 0
  end

  def evaluate(expression)
    return registers[expression] if registers.keys.include?(expression)
    expression.to_i
  end

  def copy(a, b)
    registers[b] = evaluate(a)
  end

  def increment(a)
    registers[a] += 1
  end

  def decrement(a)
    registers[a] -= 1
  end

  def jump_if_not_zero(a, b)
    not_zero = evaluate(a) != 0
    self.line += b.to_i if not_zero
    not_zero
  end

  def execute
    while running
      func, a, b = current_instruction
      case func
      when 'cpy'
        copy(a,b)
      when 'inc'
        increment(a)
      when 'dec'
        decrement(a)
      when 'jnz'
        next if jump_if_not_zero(a, b)
      end
      self.line += 1
    end
    registers
  end

  def current_instruction
    instructions[line]
  end

  def running
    line < instructions.length
  end

  private

  attr_writer :line, :registers

end