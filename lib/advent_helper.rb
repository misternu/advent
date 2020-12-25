require_relative './csv_helpers'
require_relative './print_helpers'
require_relative './auto_parser'
require_relative './overrides'
require 'yaml'

class AdventHelper
  include CSVHelpers
  include PrintHelpers

  def initialize(options = {})
    @script_root = options.fetch(:script_root, root_dir)
    @script_file = options.fetch(:script_file, '')
    clear if options.fetch(:clear, true)
    load_config
    start_counter
  end

  def load_config
    if File.exists?(File.join(root_dir, '.advent_config.yml'))
      @config = YAML.load_file(File.join(root_dir, '.advent_config.yml'))
    else
      @config = {}
    end
  end

  def start_counter
    print "\e[2J"
    print "Running #{@script_file}...\n"
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
