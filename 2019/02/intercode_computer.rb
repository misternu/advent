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
    @memory.slice(@address + 1, number)
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
