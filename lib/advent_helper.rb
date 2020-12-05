require_relative './csv_helpers'
require_relative './print_helpers'
require_relative './auto_parser'

class AdventHelper
  include CSVHelpers
  include PrintHelpers

  def initialize(options = {})
    @script_root = options.fetch(:script_root, root_dir)
    clear
  end

  def auto_parse(file = 'input.txt', options = {})
    AutoParser.parse(File.open(file_path(file)).readlines, options)
  end

  private

  def root_dir
    File.expand_path('../', File.path(__dir__))
  end

  def file_path(file)
    File.join(@script_root, file)
  end

  def open_file(file)
    File.open(file_path(file))
  rescue Errno::ENOENT
    puts "File not found: #{file}"
    []
  end

  def open_csv(file)
    CSV.read(file_path(file))
  rescue Errno::ENOENT
    puts "File not found"
    []
  end
end
