require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
# input = helper.send(:open_file, 'input.txt').read
input = helper.line_separated_strings('input.txt')
# input = helper.auto_parse
# MemoryProfiler.start(allow_files: __FILE__)
sample_1 = ["acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab |
cdfeb fcadb cdfeb cdbaf"]
sample_2 = "be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce".split("\n")
# input = sample_2

# Part 1
a = input.sum do |row|
  patterns, output = row.split('|').map(&:split)
  output.count do |n|
    length = n.length
    [2, 3, 4, 7].include?(length)
  end
end

# Part 2
def get_mapping(patterns)
  one   = patterns.find { |p| p.length == 2 }
  four  = patterns.find { |p| p.length == 4 }
  seven = patterns.find { |p| p.length == 3 }
  eight = patterns.find { |p| p.length == 7 }
  a = (seven.split('') - one.split('')).first
  bd = (four.split('') - one.split(''))
  six_segments = patterns.select { |p| p.length == 6 }
  zero_nine = six_segments
    .select { |p| one.split('').all? { |q| p.include?(q) } }
  nine = zero_nine
    .find { |p| bd.all? { |q| p.include?(q) } }
  zero = zero_nine.find { |p| p != nine }
  six = six_segments.find { |p| p != nine && p != zero }
  c = "abcdefgh".split('').find { |ch| !six.split('').include?(ch) }
  f = one.split('').find { |ch| ch != c }
  five_segments = patterns.select { |p| p.length == 5 }
  three = five_segments
    .find { |p| chars = p.split(''); chars.include?(c) && chars.include?(f) }
  five = five_segments
    .find { |p| !p.split('').include?(c) }
  two = five_segments.find { |p| p != three && p != five }
  [
    [0,zero],
    [1,one],
    [2,two],
    [3,three],
    [4,four],
    [5,five],
    [6,six],
    [7,seven],
    [8,eight],
    [9,nine]
  ].map do |n, p|
    [p.split('').sort.join, n]
  end .to_h
end

b = input.sum do |row|
  patterns, output = row.split('|').map(&:split)
  mapping = get_mapping(patterns)
  output.map { |p| mapping[p.split('').sort.join] } .map(&:to_i).join.to_i
end


# MemoryProfiler.stop.pretty_print

helper.output(a, b)
