input = File.read_lines("input.txt").map { |l| l.to_i }

p input.map { |n| (n//3) - 2 }.sum

def fuel_for(number)
  total = 0
  left = number
  until left == 0
    left = [(left//3) - 2, 0].max
    total += left
  end
  total
end

p input.map { |n| fuel_for(n) }.sum
