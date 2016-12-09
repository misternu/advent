class Person
  attr_reader :position, :path
  def initialize
    @direction = 0
    @position = [0, 0]
    @path = [[0,0]]
  end

  def turn(way)
    dr = way == "R" ? 1 : -1
    @direction = (@direction + dr) % 4
  end

  def move(distance)
    case @direction
    when 0
      @position[1] += distance
    when 1
      @position[0] += distance
    when 2
      @position[1] -= distance
    when 3
      @position[0] -= distance
    end
    trace
  end

  def trace
    a = @path.last
    b = @position
    if a[0] == b[0]
      length = (a[1] - b[1]).abs + 1
      if a[1] < b[1]
        @path += Array.new(length, a[0]).zip(a[1]..b[1])[1..-1]
      else
        @path += Array.new(length, a[0]).zip(b[1]..a[1]).reverse[1..-1]
      end
    else
      length = (a[0] - b[0]).abs + 1
      if a[0] < b[0]
        @path += (a[0]..b[0]).zip(Array.new(length, a[1]))[1..-1]
      else
        @path += (b[0]..a[0]).zip(Array.new(length, a[1])).reverse[1..-1]
      end
    end
  end

  def total
    @position[0].abs + @position[1].abs
  end
end