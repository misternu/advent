require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__, clear: false)
input = helper.line_separated_strings('input.txt')

leads_to = Hash.new

unless /(jmp|nop)/ =~ input[0]
  next_index = input.find_index { |l| /(jmp|nop)/ =~ l }
  leads_to[0] = [next_index, next_index]
end

input.each_with_index do |line, index|
  op, num = line.split(' ')
  if /(jmp|nop)/ =~ op
    jmp_index = index + num.to_i
    unless /(jmp|nop)/ =~ input[jmp_index] || index == input.length - 1
      jmp_forward = input[jmp_index+1..-1].find_index { |l| /(jmp|nop)/ =~ l }
      jmp_index = jmp_index + 1 + jmp_forward
    end
    nop_forward = input[index+1..-1].find_index { |l| /(jmp|nop)/ =~ l }
    nop_index = nop_forward ? index + 1 + nop_forward : jmp_index
    if /jmp/ =~ op
      leads_to[index] = [jmp_index, nop_index]
    else
      leads_to[index] = [nop_index, jmp_index]
    end
  end
end

positions_with_path = []
only_left = Hash.new
leads_to.each do |k, v|
  only_left[k] = v.first
end
queue = [input.length]
while queue.length > 0
  target = queue.shift
  positions = only_left.select do |key, value|
    value == target
  end .keys
  queue += positions - positions_with_path
  positions_with_path = positions_with_path | positions
end

targets = Hash.new
positions_with_path.each { |p| targets[p] = true }

def tree_search(tree, targets, path = [], position = 0, swapped = nil)
  return false if path.include?(position)
  left = tree[position][0]
  right = tree[position][1]
  return swapped if swapped && targets[left]
  return position if !swapped && targets[right]
  tree_search(tree, targets, path + [position], left) || tree_search(tree, targets, path + [position], right, right)
end

p tree_search(leads_to, targets)
