def solution(input)
  return 0 if input == 1
  layer = 1
  input -= 1
  while input > layer * 8
    input -= layer * 8
    layer += 1
  end
  input = input % (layer * 2)
  side_center = (1 + layer * 2) / 2
  difference = (input - side_center).abs
  layer + difference
end

def solution2(input)
  return 1 if input == 1
  grid = { [0,0] => 1 }
  position = [0,0]
  count = 1
end


