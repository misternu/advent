def solution(input)
  pos = 0
  steps = 0
  len = input.length
  while pos >= 0 && pos < len
    new_pos = pos + input[pos]
    input[pos] += 1
    steps += 1
    pos = new_pos
  end
  steps
end

def solution2(input)
  pos = 0
  steps = 0
  len = input.length
  while pos >= 0 && pos < len
    new_pos = pos + input[pos]
    if input[pos] >= 3
      input[pos] -= 1
    else
      input[pos] += 1
    end
    steps += 1
    pos = new_pos
  end
  steps
end
