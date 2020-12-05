class AutoParser
  attr_reader :file, :map
  def initialize(file, options = {})
    @file = file.map(&:chomp)
    @map = options.fetch(:map, false)
  end

  def parse
    return file.map { |line| line.split('') } if map
    return parse_one_line if file.length == 1
    parse_many_lines
  end

  def parse_one_line
    return file.first.split(',').map(&:to_i) if comma_separated_numbers
    file.first.chomp
  end

  def parse_many_lines
    return file.map(&:to_i) if all_numbers
    lines = file.map { |line| line.split(/\W+/) }
    if lines.all? { |line| line.length == 1 }
      lines.flatten!
    end
    lines
  end

  def self.parse(file, options = {})
    parser = self.new(file, options)
    parser.parse
  end

  private

  def comma_separated_numbers
    /(-*\d+,)*(-*\d+)/ =~ file.first
  end

  def all_numbers
    file.all? do |line|
      line =~ /^-{0,1}\d+$/
    end
  end
end