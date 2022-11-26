require 'date'

start = Time.now

while true
  elapsed = Time.now - start
  print "\e[8F"
  hundredths = (elapsed % 1 * 100).floor.to_s.rjust(2,"0")
  seconds = (elapsed.floor % 60).to_s.rjust(2,"0")
  minutes = ((elapsed.floor % 3600) / 60).to_s.rjust(2,"0")
  hours = (elapsed.floor / 3600).to_s.rjust(2,"0")
  time = "#{hours}:#{minutes}:#{seconds}.#{hundredths}"
  font_dir = '/opt/homebrew/Cellar/toilet/0.3/share/figlet'
  font_name = 'smmono9'
  system "figlet -f #{font_name} -d #{font_dir} \"#{time}\""
end
