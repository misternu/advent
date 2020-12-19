require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
input = helper.send(:open_file, 'input.txt').read
# input = helper.send(:open_file, 'sample_input.txt').read
input_rules, input_messages = input.split("\n\n").map { |part| part.split("\n") }
# input = helper.auto_parse
# input = helper.auto_parse('sample_input.txt')
# input = helper.line_separated_strings('input.txt')
# input = helper.line_separated_strings('sample_input.txt')



# Part 1
rules = Hash.new
input_rules.each do |rule|
  if rule.include?("\"")
    i, letter = rule.split(/\W+/)
    rules[i.to_i] = letter
  elsif rule.include?("|")
    i, values = rule.split(":")
    a, b = values.split("|").map { |v| v.strip.split(/\W+/).map(&:to_i) }
    rules[i.to_i] = [a, b]
  else
    i, *nums = rule.split(/\W+/).map(&:to_i)
    rules[i] = nums
    rules[i]
  end
end

def get_strings(rules, value)
  if value.first.is_a?(Array)
    return get_strings(rules, value.first) + get_strings(rules, value.last)
  end
  result = value.map do |i|
    rule = rules[i]
    if ["a", "b"].include?(rule)
      [rule]
    else
      get_strings(rules, rule)
    end
  end
  result.reduce { |acc, v| acc.product(v).map(&:join) }
end

viable_strings = Hash[get_strings(rules, [0]).collect { |i| [i, true] }]

a = input_messages.count do |message|
  viable_strings[message]
end


# Part 2
# 8: 42 | 42 8
# 11: 42 31 | 42 11 31
# p fourty_two = get_strings(rules, [42]).uniq
# p thirty_one = get_strings(rules, [31]).uniq

def search(rules, string, rule_id, values)
  # p [string, values]
  rule = rules[rule_id]
  if rule.is_a?(String)
    if values.empty?
      string == rule
    else
      string[0] == rule && search(rules, string[1..-1], values[0], values[1..-1])
    end
  elsif rule.first.is_a?(Array)
    rule.any? do |variant|
      new_values = variant + values
      search(rules, string, new_values[0], new_values[1..-1])
    end
  else
    new_values = rule + values
    search(rules, string, new_values[0], new_values[1..-1])
  end
end

rules[8] = [[42], [42,8]]
rules[11] = [[42,31], [42,11,31]]

b = input_messages.count do |message|
  value = search(rules, message, 0, [])
  if value
    p message
  end
  !!value
end
# b = nil
# b = search(rules, "abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa", 0, [])


helper.output(a, b)
