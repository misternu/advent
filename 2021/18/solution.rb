require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)
# input = sample_input



# Part 1
def get_locations(number)
  return [[]] unless number.is_a?(Array)
  a, b = number
  a_loc = get_locations(a).map { |l| [0] + l }
  b_loc = get_locations(b).map { |l| [1] + l }
  a_loc + b_loc
end

def get_from_location(number, i)
  return number[i.first] if i.length == 1
  head = i.first
  get_from_location(number[head], i[1..-1]) 
end

def set_at_location(number, value, i)
  if i.length == 1
    number[i.first] = value
    return
  end
  head = i.first
  set_at_location(number[head], value, i[1..-1])
end

def find_explosion_index(locations)
  (0...locations.length-1).each do |i|
    this_location = locations[i]
    next unless this_location.length > 4
    next unless this_location.last == 0
    next_location = locations[i+1]
    next unless this_location[0...-1] == next_location[0...-1]
    return [i, i+1]
  end
  nil
end

def find_split_location(number)
  number.flatten.index { |n| n > 9 }
end

def magnitude(number)
  return number if number.is_a?(Integer)
  3 * magnitude(number[0]) + 2 * magnitude(number[1])
end

input_a = input.dup.map { |l| eval(l) }
# input_a = [
#   [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]],
#   [[[5,[2,8]],4],[5,[[9,9],0]]],
#   [6,[[[6,2],[5,6]],[[7,6],[4,7]]]],
#   [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]],
#   [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]],
#   [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]],
#   [[[[5,4],[7,7]],8],[[8,3],8]],
#   [[9,3],[[9,9],[6,[4,9]]]],
#   [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]],
#   [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
# ]
while true
  reducing = false
  input_a.each do |number|
    locations = get_locations(number)
    if explode = find_explosion_index(locations)
      x, y = explode
      if x > 0
        value = get_from_location(number, locations[x])
        dest = get_from_location(number, locations[x-1])
        set_at_location(number, dest + value, locations[x-1])
      end
      if y < locations.length - 1
        value = get_from_location(number, locations[y])
        dest = get_from_location(number, locations[y+1])
        set_at_location(number, dest + value, locations[y+1])
      end
      set_at_location(number, 0, locations[x][0...-1])
      reducing = true
      next
    end
    if split = find_split_location(number)
      value = get_from_location(number, locations[split])
      pair = [value / 2, value - (value / 2)]
      set_at_location(number, pair, locations[split])
      reducing = true
      next
    end
  end
  next if reducing
  if input_a.length > 1
    a, b = input_a.shift(2)
    input_a.unshift([a, b])
    next
  else
    break
  end
  # break
end
a = magnitude(input_a.first)

# Part 2
input_b = input.dup
max_b = 0
input_b.combination(2).each do |pair|
  sum = pair.map { |l| eval(l) }
  while true
    reducing = false
    sum.each do |number|
      locations = get_locations(number)
      if explode = find_explosion_index(locations)
        x, y = explode
        if x > 0
          value = get_from_location(number, locations[x])
          dest = get_from_location(number, locations[x-1])
          set_at_location(number, dest + value, locations[x-1])
        end
        if y < locations.length - 1
          value = get_from_location(number, locations[y])
          dest = get_from_location(number, locations[y+1])
          set_at_location(number, dest + value, locations[y+1])
        end
        set_at_location(number, 0, locations[x][0...-1])
        reducing = true
        next
      end
      if split = find_split_location(number)
        value = get_from_location(number, locations[split])
        new_pair = [value / 2, value - (value / 2)]
        set_at_location(number, new_pair, locations[split])
        reducing = true
        next
      end
    end
    next if reducing
    if sum.length > 1
      x, y = sum.shift(2)
      sum.unshift([x, y])
      next
    else
      break
    end
  end
  mag = magnitude(sum.first)
  max_b = [max_b, mag].max
end
b = max_b



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
