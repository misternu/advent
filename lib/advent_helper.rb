require_relative './csv_helpers'
require_relative './print_helpers'
require_relative './auto_parser'
require_relative './overrides'

class AdventHelper
  include CSVHelpers
  include PrintHelpers

  def initialize(options = {})
    @script_root = options.fetch(:script_root, root_dir)
    clear if options.fetch(:clear, true)
    start_counter
  end

  def start_counter
    print "\e[2J"
    print "Running #{__FILE__}...\n"
    @counter = Thread.new {
      start = Time.now
      while true do
        puts "\e[2H" + "#{(Time.now - start).round(1)}" + " " * 10
        sleep 0.1
      end
    }
  end

  def stop_counter
    @counter.exit
  end

  def auto_parse(file = 'input.txt', options = {})
    AutoParser.parse(File.open(file_path(file)).readlines, options)
  end

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
