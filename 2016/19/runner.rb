input = 3005290

# Part 1
power = 0
until 2 ** (power+1) > input
  power += 1
end
p (input - (2 ** power)) * 2 + 1

# Part 2
([input]).each do |number|
  soldiers = (1..number).to_a
  until soldiers.length == 1
    p soldiers.length if soldiers.length % 1000 == 0
    index = (soldiers.length / 2).floor
    soldiers.delete_at(index)
    soldiers << soldiers.shift
  end
  puts "#{number} #{soldiers.first}"
end