require 'json'
zones_off_of_eastern = 2
offset = 3600 * zones_off_of_eastern
day_to_display = ARGV[0] || "1"
data = JSON.parse(File.read("stats.json"))

star_one_times = {}
star_two_times = {}
data["members"].each do |id, member|
  next unless member["completion_day_level"].keys.include?(day_to_display)
  member_name = member["name"]
  star_one_times[member_name] = member["completion_day_level"][day_to_display]["1"]["get_star_ts"] + offset
  if member["completion_day_level"][day_to_display].keys.include?("2")
    star_two_times[member_name] = member["completion_day_level"][day_to_display]["2"]["get_star_ts"] + offset
  end
end

part_1 = star_one_times.to_a.sort_by { |n, t| t }
part_2 = star_two_times.to_a.sort_by { |n, t| t }

puts "Part 1:"
part_1.each_with_index do |nt, i|
  n, t = nt
  puts "#{i+1} #{n.ljust(15)} #{Time.at(t).strftime("%b%e %H:%M:%S")}"
end
puts "\nPart 2:"
part_2.each_with_index do |nt, i|
  n, t = nt
  puts "#{i+1} #{n.ljust(15)} #{Time.at(t).strftime("%b%e %H:%M:%S")}"
end
