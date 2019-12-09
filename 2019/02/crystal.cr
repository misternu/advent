class IntcodeComputer
  def initialize(memory : Array(Int32), noun : Int32, verb : Int32)
    @memory = memory
    @memory = memory.dup
    @address = 0
    @noun = noun
    @verb = verb
    @memory[1] = @noun
    @memory[2] = @verb
  end

  def run
    if operate
      step
      run
    else
      halt
    end
  end

  def operate
    case opcode
    when 1
      add
      true
    when 2
      multiply
      true
    when 99
      false
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
    if [1, 2].includes?(opcode)
      get(3)
    else
      get(0)
    end
  end

  def get(number)
    @memory[(@address + 1)..(@address + 1 + number)]
  end

  def step
    if [1, 2].includes?(opcode)
      @address += 4
    end
  end

  def halt
    @memory[0..3]
  end
end

input = File.read("input.txt").split(',').map { |n| n.to_i }

computer = IntcodeComputer.new(input, 12, 2)
p computer.run[0]

target = 19690720
(0..99).each do |noun|
  found = false
  (0..99).each do |verb|
    computer = IntcodeComputer.new(input, noun, verb)
    result = computer.run[0]
    if result == target
      p 100 * noun + verb
      found = true
      break
    end
  end
  break if found
end
