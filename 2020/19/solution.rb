require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
input = helper.send(:open_file, 'input.txt').read
# input = helper.send(:open_file, 'sample_input.txt').read
input_rules, input_messages = input.split("\n\n").map { |part| part.split("\n") }
# input = helper.auto_parse
# input = helper.auto_parse('sample_input.txt')
# input = helper.line_separated_strings('input.txt')
# input = helper.line_separated_strings('sample_input.txt')



rules = Hash.new
input_rules.each do |rule|
  if rule.include?("\"")
    i, value = rule.split(/\W+/)
  else
    i, variants = rule.split(":")
    value = variants.split("|").map { |v| v.strip.split(/\W+/).map(&:to_i) }
  end
  rules[i.to_i] = value
end

def search(rules, string, rule_id = 0, values = [])
  rule = rules[rule_id]
  if rule.is_a?(String)
    return string == rule if values.empty?
    return string[0] == rule && search(rules, string[1..-1], values[0], values[1..-1])
  end
  rule.any? do |variant|
    new_values = variant + values
    search(rules, string, new_values[0], new_values[1..-1])
  end
end

# Part 1
a = input_messages.count { |message| search(rules, message) }

# Part 2
# 8: 42 | 42 8
# 11: 42 31 | 42 11 31

rules[8] = [[42], [42,8]]
rules[11] = [[42,31], [42,11,31]]

b = input_messages.count { |message| search(rules, message) }


helper.output(a, b)
