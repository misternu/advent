require_relative '../../lib/advent_helper'

helper = AdventHelper.new(script_root:__dir__)

input = helper.line_separated_strings('input.txt')
input.map! do |line|
  vars = line.scan(/\w=([^,> ]*)/).flatten.map(&:to_i)
end

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

  def all
    @collection
  end

  def move
    @collection.map(&:move)
  end

  def state
    @collection.map(&:coords).transpose.zip(@collection.map(&:velocity).transpose)
  end
end

class FloatingBody
  def initialize(options = { coords: [0, 0, 0], velocity: [0, 0, 0] })
    @x, @y, @z = options.fetch(:coords)
    @dx, @dy, @dz = options.fetch(:velocity, [0, 0, 0])
  end

  def coords
    [@x, @y, @z]
  end

  def velocity
    [@dx, @dy, @dz]
  end

  def gravitate(other)
    other_coords = other.coords
    @dx += other_coords[0] <=> @x
    @dy += other_coords[1] <=> @y
    @dz += other_coords[2] <=> @z
  end

  def move
    @x += @dx
    @y += @dy
    @z += @dz
  end

  def energy
    coords.map(&:abs).sum * velocity.map(&:abs).sum
  end
end

# Part 1
bodies = Collection.new(FloatingBody)
input.each do |coords|
  bodies.find_or_create(coords: coords)
end

1000.times do
  bodies.all.combination(2).each do |a, b|
    a.gravitate(b)
    b.gravitate(a)
  end
  bodies.all.each do |body|
    body.move
  end
  bodies.all.map(&:coords)
end

p bodies.all.map(&:energy).sum

# Part 2
example1 = [
  [-1, 0, 2],
  [2, -10, -7],
  [4, -8, 8],
  [3, 5, -1]
]
example2 = [
  [-8, -10, 0],
  [5, 5, 10],
  [2, -7, 3],
  [9, -8, -3]
]

bodies2 = Collection.new(FloatingBody)
input.each do |coords|
  bodies2.find_or_create(coords: coords)
end

knownx = Hash.new
knowny = Hash.new
knownz = Hash.new
steps = 0

xcycle = nil
ycycle = nil
zcycle = nil

animate = true

if animate
  require 'colorize'
  COLORS = [:red, :green, :yellow, :blue]
  xmax, xmin, ymax, ymin, zmax, zmin = [1770, -1795, 1093, -1795, 2295, -2178]
end

def distance(a, b)
  Math.sqrt((b[0] - a[0]).abs ** 2 + (b[1] - a[1]).abs ** 2)
end

minz, maxz = [0, 0]

until xcycle && ycycle && zcycle do
  state = bodies2.state
  knownx[state[0]] = true
  knowny[state[1]] = true
  knownz[state[2]] = true

  if animate && steps > 130000 && steps % 2 == 0
    pixel_size = 30
    bodies = state.map(&:first).transpose
    puts "\e[H"
    ymax.downto(ymin).each_slice(pixel_size) do |y|
      ay = y.first
      puts (xmin..xmax).each_slice(pixel_size).map { |x|
        ax = x.first
        in_range = bodies.select do |body|
          size = pixel_size * ((body.last + zmin.abs + 500) / 447.3)
          distance([ax, ay], body[0..1]) < size
        end
        if in_range.any?
          foreground = in_range.max_by { |b| b.last }
          bodies.index(foreground)
          "#".colorize(COLORS[bodies.index(foreground)])
        else
          " "
        end
      }.join
    end
    sleep 0.01
  end

  steps += 1
  bodies2.all.combination(2).each do |a, b|
    a.gravitate(b)
    b.gravitate(a)
  end
  bodies2.move

  new_state = bodies2.state
  xcycle ||= steps if knownx[new_state[0]]
  ycycle ||= steps if knowny[new_state[1]]
  zcycle ||= steps if knownz[new_state[2]]
end

unless animate
  p [xcycle, ycycle, zcycle].reduce(1, :lcm)
end