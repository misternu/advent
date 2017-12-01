class Screen
  attr_reader :width, :height, :pixels
  def initialize(options = {})
    @width = options.fetch(:width, 50)
    @height = options.fetch(:height, 6)
    @pixels = Array.new(@height) { Array.new(@width, ".") }
  end

  def rect(width, height)
    (0...height).each do |row|
      (0...width).each do |col|
        @pixels[row][col] = "#"
      end
    end
  end

  def rotate_col(col, dist)
    new_pixels = @pixels.transpose
    new_pixels[col] = rotate(new_pixels[col], dist)
    @pixels = new_pixels.transpose
  end

  def rotate_row(row, dist)
    @pixels[row] = rotate(@pixels[row], dist)
  end

  def rotate(array, dist)
    array.last(dist) + array.first(array.length-dist)
  end

  def to_s
    @pixels.map do |row|
      row.join
    end .join("\n")
  end
end