require_relative 'room'

file = File.open('input.txt')

real_rooms = []

file.each_line do |line|
  room = Room.new(line)
  real_rooms << room if room.valid
end

# p real_rooms.inject(0) { |sum, room| sum + room.id }

real_rooms.each do |room|
  name = room.decode
  if name.include?("pole")
    puts name
    puts room.id
  end
end