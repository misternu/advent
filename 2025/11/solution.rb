require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root: __dir__, counter: false)
input = helper.auto_parse
sample_input = helper.auto_parse('sample_input.txt')
aux_input = helper.auto_parse('aux_input.txt')
# MemoryProfiler.start(allow_files: __FILE__)

# input = sample_input

OUT = "out".freeze
DAC = "dac".freeze
FFT = "fft".freeze

# Part 1
edges = {}
input.each do |row|
  edges[row[0]] = row[1..]
end

a = 0
queue = ["you"]
until queue.empty?
  pos = queue.shift

  edges[pos].each do |e|
    if e == OUT
      a += 1
      next
    end
    queue << e
  end
end

class PathCounter
  def initialize(edges)
    @edges = edges
    @memo = {}
    # @visiting = {}
  end

  def count_paths(node)
    return @memo[node] if @memo[node]
    # return [0, 0, 0, 0] if @visiting[node]
    return [1, 0, 0, 0] if node == OUT

    # @visiting[node] = true

    totals = [0, 0, 0, 0]
    @edges[node].each do |e|
      out_count, dac_count, fft_count, both_count = count_paths(e)

      case node
      when DAC
        totals[1] += out_count
        totals[3] += fft_count
      when FFT
        totals[2] += out_count
        totals[3] += dac_count
      else
        totals[0] += out_count
        totals[1] += dac_count
        totals[2] += fft_count
        totals[3] += both_count
      end
    end

    # @visiting.delete(node)
    @memo[node] = totals
    totals
  end
end

counter = PathCounter.new(edges)
counts = counter.count_paths("svr")
b = counts[3]

# MemoryProfiler.stop.pretty_print
helper.output(a, b)
