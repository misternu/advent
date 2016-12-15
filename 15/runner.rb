require_relative 'disc'

discs = File.open('input.txt').readlines.map(&:strip).map do |disc|
  positions, initial = /(\d+) pos.*ion (\d+)/.match(disc).captures.map(&:to_i)
  Disc.new(positions, initial)
end

def right_time(discs, time)
  discs.each_with_index do |disc, index|
    return false unless disc.open_at_t(time + index + 1)
  end
  return true
end

# PART 1
time = 0
until right_time(discs, time) do
  time += 1
end
p time

# PART 2
discs << Disc.new(11,0)
time = 0
until right_time(discs, time) do
  time += 1
end
p time