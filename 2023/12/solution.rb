require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__, counter: false)
# input = helper.send(:open_file, 'input.txt').read
input = helper.line_separated_strings('input.txt')
sample_input = helper.line_separated_strings('sample_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

input = sample_input

# Part 1
input = input.map do |line|
  pattern, numbers = line.split
  numbers = numbers.split(",").map(&:to_i)
  [pattern, numbers]
end

def search(pattern, numbers)
  count = 0
  queue = [[pattern.dup, numbers.dup]]

  until queue.empty?
    pat, nums = queue.shift

    if pat == ""
      count += 1 if nums.empty?
      next
    end

    if pat[0] == "."
      if pat.length > 0
        queue << [pat[1..], nums] 
      end
      next
    end

    if /^#+(\.|$)/ =~ pat
      i = pat.chars.index { |ch| ch != '#' }
      if i.nil? && nums.length == 1 && pat.length == nums[0]
        count += 1
        next
      end
      next if nums.empty?
      next if i != nums.first
      queue << [pat[(i+1)..], nums[1..]]
      next
    end

    if nums.empty? && !pat.include?('#')
      count += 1
      next
    end

    i = pat.index('?')
    if i == 0
      queue = queue + [[pat.sub('?', '#'), nums], [pat[1..], nums]]
      next
    end
    next if i > nums[0]
    queue = queue + [[pat.sub('?', '#'), nums], [pat.sub('?', '.'), nums]]
  end

  count
end

a = input.sum do |pat, nums|
  search(pat, nums)
end

# Part 2
def masks(pat)
  oh, one = 0, 0
  len = pat.length
  (0...len).each do |i|
    case pat[i]
    when '.'
      oh |= 2 ** (len-i-1)
    when '#'
      one |= 2 ** (len-i-1)
    end
  end
  [oh, one]
end

def wiggle(pat, nums)
  pat.length - nums.sum - nums.length + 1
end

def permutations(len, wiggle, nums)
  Enumerator.new do |yielder|
    (0..wiggle).to_a.repeated_permutation(nums.length).each do |comb|
      next if comb.sum > wiggle
      num = 0
      offset = 0
      comb.each_with_index do |x, i|
        num += (2 ** (len-x-offset)) - (2 ** (len-x-nums[i]-offset))
        offset += nums[i] + 1 + x
      end
      yielder << num
    end
  end
end

def count(pat, nums)
  oh, one = masks(pat)
  w = wiggle(pat, nums)
  ps = permutations(pat.length, w, nums)

  ps.count do |num|
    num.nobits?(oh) && num.allbits?(one)
  end
end

b = input.sum do |pat, nums|
  five_pat = (0...5).map { |s| pat } .join('?')
  five_nums = nums * 5
  count(five_pat, five_nums)
end



# MemoryProfiler.stop.pretty_print
helper.output(a, b)
