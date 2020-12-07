require 'yaml'

if File.exists?('.advent_config.yml')
  config = YAML.load_file(File.join(File.path(__dir__), '.advent_config.yml'))
else
  config = {}
end

year, day = config['directory'].split('/')
day = day.to_i.to_s

target = File.join(File.path(__dir__), config['directory'], 'input.txt')

while true
  sleep 1
  time = Time.now
  if time.hour == 23 && time.sec > 10 || time.hour == 23 && time.min > 0
    break
  end
end

system("curl --cookie \"session=$(cat ${HOME}/.aocrc)\" https://adventofcode.com/#{year}/day/#{day}/input > #{target}")