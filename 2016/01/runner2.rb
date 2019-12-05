p instructions = File.read('input.csv').split(', ')

def navigator(input)
  pos = [0,0]
  dir = 0
  input.each do |instr|
    if instr[0] == "R"
      dir = (dir + 1) % 4
    else
      dir = (dir - 1) % 4
    end
    distance = instr[1..-1].to_i
    case dir
    when 0 then pos[1] += distance
    when 1 then pos[0] += distance
    when 2 then pos[1] -= distance
    when 3 then pos[0] -= distance
    end
  end
  # we done, implicit return what?
  # pos.map(&:abs).reduce(&:+)
  pos[0].abs + pos[1].abs
end

p navigator(instructions)
