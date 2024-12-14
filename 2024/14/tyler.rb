PATH = './inputs/day_14.txt'.freeze
INPUT = File.open(PATH).readlines.freeze
XMAX = 102
YMAX = 104
SECS = 100

puts "Successfully read input from #{PATH}" if INPUT

class DayFourteen
  def initialize
    @robots = {}
    @quadrants = []
    process(INPUT)
  end

  def process(lines)
    lines.each_with_index do |line ,rdex|
      x, y, dx, dy = line.match(/p=([\-0-9]+),([\-0-9]+) v=([\-0-9]+),([\-0-9]+)/).captures.map(&:to_i)
      @robots[rdex] = { x: x, y: y, dx: dx, dy: dy }
    end
  end

  def part_one
    march_robots
    herd_robots
    calculate_robots_in_quadrants
    report(@quadrants.inject(:*), 'Safety Factor')
  end

  def march_robots
    @robots.each do |_, robot|
      robot[:x] += robot[:dx] * SECS
      robot[:y] += robot[:dy] * SECS
    end
    # puts @robots.inspect
  end

  def herd_robots
    x_factor = XMAX + 1
    y_factor = YMAX + 1
    @robots.each do |_, robot|
      while robot[:x] < 0
        robot[:x] += x_factor
      end
      while robot[:x] > XMAX
        robot[:x] -= x_factor
      end
      while robot[:y] < 0
        robot[:y] += y_factor
      end
      while robot[:y] > YMAX
        robot[:y] -= y_factor
      end
    end
    # print_map
  end

  def print_map
    (0..YMAX).each do |y|
      (0..XMAX).each do |x|
        count = @robots.count { |_, robot| robot[:x] == x && robot[:y] == y }
        if x == XMAX / 2 || y == YMAX / 2
          print ' '
        else
          print count > 0 ? count : '.'
          # print count > 0 ? @robots.find { |_, robot| robot[:x] == x && robot[:y] == y }[0] : '.'
        end
      end
      puts
    end
  end

  def calculate_robots_in_quadrants
    quadrant_counts = Hash.new(0)
    @robots.each do |_, robot|
      if robot[:x] > XMAX / 2 && robot[:y] > YMAX / 2
        quadrant_counts[:q1] += 1
      elsif robot[:x] < XMAX / 2 && robot[:y] > YMAX / 2
        quadrant_counts[:q2] += 1
      elsif robot[:x] < XMAX / 2 && robot[:y] < YMAX / 2
        quadrant_counts[:q3] += 1
      elsif robot[:x] > XMAX / 2 && robot[:y] < YMAX / 2
        quadrant_counts[:q4] += 1
      end
    end
    @quadrants = quadrant_counts.values
  end

  def report(value, name = nil)
    puts "#{name}: #{value}"
    system("echo #{value} | pbcopy")
    puts "Copied to clipboard!"
  end

  def part_two
  end
end

day_fourteen = DayFourteen.new
puts '--- Part 1 ---'
day_fourteen.part_one
puts '--- Part 2 ---'
day_fourteen.part_two
