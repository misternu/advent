require_relative 'bot'

bots = Hash.new() { |h, k| h[k] = Bot.new }
outputs = Hash.new() { |h, k| h[k] = Array.new }

File.open('input.txt').each_line do |instr|
  if /^bot / =~ instr
    bot, ta, a, tb, b = /(\d+).* (\w+) (\d+).* (\w+) (\d+)/.match(instr).captures
    bot, a, b = [bot, a, b].map(&:to_i)
    bots[bot].outputs = {
      low: ta == "output" ? outputs[a] : bots[a],
      high: tb == "output" ? outputs[b] : bots[b]
    }
  elsif /^value / =~ instr
    value, bot = instr.scan(/(\d+)/).flatten.map(&:to_i)
    bots[bot] << value
  end
end

A = 17
B = 61
target = [A,B].sort

until bots.values.none?(&:ready?)
  id, bot = bots.find { |id, bot| bot.ready? }
  p id if bot.chips.sort == target
  bot.execute
end

p outputs[0].first * outputs[1].first * outputs[2].first