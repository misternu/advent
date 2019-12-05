def solution(input)
  (0...input.length).reduce(0) do |memo, index|
    input[index] == input[index-1] ? memo + input[index].to_i : memo
  end
end

def solution2(input)
  len = input.length
  (0...len).reduce(0) do |memo, index|
    input[index] == input[index-len/2] ? memo + input[index].to_i : memo
  end
end
