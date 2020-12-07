while true
  sleep 1
  time = Time.now

  puts "#{time.hour} #{Time.now.to_i - Time.beginning_of_hour.to_i}"
end