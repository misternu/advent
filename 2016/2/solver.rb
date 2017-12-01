class Solver
  attr_reader :position, :instructions
  def initialize(instructions, numpad = [["1","2","3"],["4","5","6"],["7","8","9"]])
    @instructions = instructions
    @numpad = numpad
    @code = ""
    @position = find_start
  end

  def find_start
    @numpad.each_index do |row|
      @numpad[row].each_index do |col|
        return [col, row] if @numpad[row][col] == "5"
      end
    end
  end

  def move(direction)
    case direction
    when 'U'
      return if @position[1] == 0
      return if @numpad[@position[1] - 1][@position[0]] == nil
      @position[1] = @position[1] - 1
    when 'R'
      return if @position[0] + 1 == @numpad[0].length
      return if @numpad[@position[1]][@position[0] + 1] == nil
      @position[0] = @position[0] + 1
    when 'D'
      return if @position[1] + 1 == @numpad.length
      return if @numpad[@position[1] + 1][@position[0]] == nil
      @position[1] = @position[1] + 1
    when 'L'
      return if @position[0] == 0
      return if @numpad[@position[1]][@position[0] - 1] == nil
      @position[0] = @position[0] - 1
    end
  end

  def solve
    @instructions.each do |instruction|
      instruction.split('').each do |direction|
        move(direction)
      end
      @code += @numpad[@position[1]][@position[0]]
    end
    @code
  end
end