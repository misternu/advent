require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
# responses = input.split("\n\n").map { |r| r.split(/\s+/).map(&:chars) }
# input = helper.auto_parse
# input = helper.auto_parse('sample_input.txt')
input = helper.line_separated_strings('input.txt')
# input = helper.line_separated_strings('sample_input.txt')


def tokenize(string)
  if string.include?("(")
    starting_index = string.index("(")
    count = 1
    ending_index = starting_index + 1
    while true
      if string[ending_index] == ")"
        count -= 1
        break if count == 0
      elsif string[ending_index] == "("
        count += 1
      end
      ending_index += 1
    end
    a = tokenize(string[0...starting_index])
    b = tokenize(string[starting_index+1...ending_index])
    c = tokenize(string[ending_index+1..-1])
    a + [b] + c
  else
    string.split(' ')
  end
end

def evaluate(string, ordered = false)
  tokens = tokenize(string)
  token_reduce(tokens, ordered).to_i
end

def token_reduce(tokens, ordered = false)
  return tokens if tokens.is_a?(String)
  return tokens.first if tokens.length < 2
  plus_index = tokens.find_index("+")
  if plus_index && ordered
    a = token_reduce(tokens[plus_index-1], ordered).to_i
    c = token_reduce(tokens[plus_index+1], ordered).to_i
    token_reduce(tokens[0...plus_index-1] + [(a+c).to_s] + tokens[plus_index+2..-1], ordered)
  else
    a = token_reduce(tokens[0], ordered).to_i
    c = token_reduce(tokens[2], ordered).to_i
    value = tokens[1] == "+" ? (a+c).to_s : (a*c).to_s
    token_reduce([value] + tokens[3..-1], ordered)
  end
end

# Part 1
output = input.map {|line| evaluate(line)}
a = output.sum

# Part 2
output = input.map {|line| evaluate(line, true)}
b = output.sum



helper.output(a, b)
