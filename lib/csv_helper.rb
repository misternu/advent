require 'csv'

module CSVHelpers
  def word(file)
    open_file(file).first.strip
  end

  def comma_separated_strings(file)
    CSV.read(file_path(file)).flatten.map(&:strip)
  rescue Errno::ENOENT 
    puts "File not found"
    []
  end

  def line_separated_strings(file)
    open_file(file).map(&:chomp)
  end

  def whitespace_table(file)
    open_file(file).map do |row|
      row.gsub(/\s+/m, ' ').strip.split(" ")
    end
  end
end