require_relative './csv_helpers'
require_relative './print_helpers'
require_relative './auto_parser'
require_relative './overrides'
require 'yaml'

class AdventHelper
  include CSVHelpers
  include PrintHelpers

  attr_reader :script_root, :script_file, :options
  def initialize(options = {})
    @options = options
    @script_root = options.fetch(:script_root, root_dir)
    @script_file = options.fetch(:script_file, nil)
    clear if options.fetch(:clear, false)
    load_config
    start_counter if options.fetch(:counter, true)
  end

  def load_config
    if File.exists?(File.join(root_dir, '.advent_config.yml'))
      @config = YAML.load_file(File.join(root_dir, '.advent_config.yml'))
    else
      @config = {}
    end
  end

  def start_counter
    puts "-" * 30
    puts "Running #{script_file}...\n" if script_file
    puts "\n"
    @counter = Thread.new {
      start = Time.now
      while true do
        puts "\e[0F" + "#{(Time.now - start).round(1)} Seconds"
      end
    }
  end

  def stop_counter
    return unless options.fetch(:counter, true)
    @counter.exit
  end

  def auto_parse(file = 'input.txt', options = {})
    unless File.exist?(file_path(file))
      puts 'no input file'
      return
    end
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
