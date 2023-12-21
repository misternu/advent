require_relative '../../lib/advent_helper'
# require 'memory_profiler'
helper = AdventHelper.new(script_root:__dir__)
input = helper.send(:open_file, 'input.txt').read
sample_input = helper.send(:open_file, 'sample_input.txt').read
# MemoryProfiler.start(allow_files: __FILE__)

input = sample_input

# Part 1
definitions, parts = input.split("\n\n").map { |x| x.split("\n")}

class Workflow
  attr_accessor :name
  def initialize(string)
    matches = /(.+)\{(.+)\}/.match(string)
    @name = matches[1]
    rule_strings = matches[2].split(',')
    @rules = rule_strings.map do |str|
      if /[<>]/ =~ str
        sym = str[0].to_sym
        op = str[1]
        num = /\d+/.match(str)[0].to_i
        res = /:(.+)/.match(str)[1] 
        if op == ">"
          lambda { |v| v[sym] > num ? res : nil }
        elsif op == "<"
          lambda { |v| v[sym] < num ? res : nil }
        end
      else
        lambda { |v| str }
      end
    end
  end

  def run(v)
    @rules.each do |rule|
      result = rule.call(v)
      return result if result
      next
    end
  end
end



workflows = {}

definitions.each do |line|
  flow = Workflow.new(line)
  workflows[flow.name] = flow
end

def process(workflows, part)
  name = "in"
  until name == "A" || name == "R"
    name = workflows[name].run(part)
  end
  name
end

parts.map! do |part|
  x, m, a, s = part.scan(/\d+/).map(&:to_i)
  { x: x, m: m, a: a, s: s }
end

eh = parts.sum do |part|
  result = process(workflows, part)
  if result == "A"
    part.values.sum
  else
    0
  end
end

# Part 2

class WorkflowSearch
  def initialize(workflows)
    @workflows = {}
    workflows.each do |wf|
      matches = /(.+)\{(.+)\}/.match(wf)
      rules = matches[2].split(',').map do |str|
        if /[<>]/ =~ str
          sym, op = str[0].to_sym, str[1]
          num, res = /\d+/.match(str)[0].to_i, /:(.+)/.match(str)[1] 
          if op == ">"
            [:gt, num, res]
          else
            [:lt, num, res]
          end
        else
          [:str, str]
        end
      end
      @workflows[matches[1]] = rules
    end
  end

  def search
    queue = [["in", { x: [1, 4000], m: [1, 4000], a: [1, 4000], s: [1, 4000] }]]
    until queue.empty?
      wf, part = queue.shift
      rules = @workflows[wf]
      
    end
  end
end

wfs = WorkflowSearch.new(definitions)
wfs = wfs.search

b = nil



# MemoryProfiler.stop.pretty_print
helper.output(eh, b)
