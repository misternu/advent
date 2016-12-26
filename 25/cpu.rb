class UnknownCommand < StandardError
end

class CPU
  attr_reader :instructions, :registers, :line, :cycles, :output
  def initialize(instructions, options = {})
    @instructions = instructions
    @registers = options.fetch(:registers, Hash.new(0))
    @line = 0
    @cycles = 0
    @output = ""
  end

  def evaluate(expression)
    return registers[expression] if registers.keys.include?(expression)
    expression.to_i
  end

  def copy(a, b)
    return nil unless ["a", "b", "c", "d"].include?(b)
    registers[b] = evaluate(a)
  end

  def increment(a, amount = 1)
    return nil unless ["a", "b", "c", "d"].include?(a)
    registers[a] += amount
  end

  def decrement(a, amount = 1)
    return nil unless ["a", "b", "c", "d"].include?(a)
    registers[a] -= amount
  end

  def jump_if_not_zero(a, b)
    if evaluate(a) != 0 && evaluate(b) != 0
      self.line += evaluate(b)
      return true
    end
    false
  end

  def toggle(a)
    index = line + evaluate(a)
    # sleep(60) if index > 0 && index < instructions.length
    func, a, b = instructions[index]
    case func
    when 'inc'
      instructions[index][0] = 'dec'
    when 'dec'
      instructions[index][0] = 'inc'
    when 'tgl'
      instructions[index][0] = 'inc'
    when 'jnz'
      instructions[index][0] = 'cpy'
    when 'cpy'
      instructions[index][0] = 'jnz'
    end
  end

  def reduced_instruction
    if current_instruction.first == 'inc' &&
       current_instruction(1).first == 'dec' &&
       current_instruction(2) == ['jnz', current_instruction(1)[1], '-2'] &&
       current_instruction(3).first == 'dec' &&
       current_instruction(4).first == 'jnz' &&
       current_instruction(4).last == '-5' &&
       current_instruction(3)[1] == current_instruction(4)[1]
      a = current_instruction(1)[1]
      b = current_instruction(3)[1]
      increment(current_instruction[1], evaluate(a) * evaluate(b))
      registers[current_instruction(1)[1]] = 0
      self.line += 5
      return true
    elsif current_instruction.first == 'dec' &&
          current_instruction(1).first == 'inc' &&
          current_instruction(2) == ['jnz', current_instruction[1], '-2'] &&
          current_instruction(3).first == 'dec' &&
          current_instruction(4).first == 'jnz' &&
          current_instruction(4).last == '-5' &&
          current_instruction(3)[1] == current_instruction(4)[1]
      a = current_instruction[1]
      b = current_instruction(3)[1]
      increment(current_instruction(1)[1], evaluate(a) * evaluate(b))
      registers[current_instruction[1]] = 0
      self.line += 5
      return true
    end
    false
  end

  def out(a)
    self.output += evaluate(a).to_s
  end

  def execute(max = 0)
    while running
      self.cycles += 1
      return registers if cycles == max
      return registers if output.length == 100
      next if reduced_instruction
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
      when 'tgl'
        toggle(a)
      when 'out'
        out(a)
      end
      self.line += 1
    end
    registers
  end

  def current_instruction(c = 0)
    instructions[line + c]
  end

  def running
    line < instructions.length
  end

  private

  attr_writer :instructions, :registers, :line, :cycles, :output

end