require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__)
input = helper.line_separated_strings('input.txt').map { |orbit| orbit.split(')') }

class Collection
  attr_reader :klass
  def initialize(klass)
    @klass = klass
    @collection = []
  end

  def find(options)
    @collection.find do |instance|
      options.all? do |key, value|
        instance.send(key) == value
      end
    end
  end

  def find_or_create(options)
    instance = find(options)
    unless instance
      instance = klass.new(options)
      @collection << instance
    end
    instance
  end

  def sum(method)
    @collection.map(&method).sum
  end
end

class OrbitalBody
  attr_reader :title
  attr_accessor :parent
  def initialize(options = {})
    @title = options.fetch(:title)
    @parent = options.fetch(:parent, nil)
  end

  def orbit_count
    parents.count
  end

  def parents
    return [] unless parent
    [parent.title] + parent.parents
  end
end

class OrbitalBodyCollection < Collection
  def initialize
    super(OrbitalBody)
  end
end

bodies = OrbitalBodyCollection.new

input.each do |orbit|
  parent_name, child_name = orbit
  parent = bodies.find_or_create(title: parent_name)
  child = bodies.find_or_create(title: child_name)
  child.parent = parent
end

# Part 1
p bodies.sum(:orbit_count)

# Part 2
a = bodies.find(title: "YOU").parents
b = bodies.find(title: "SAN").parents
p ((a - b) + (b - a)).count
