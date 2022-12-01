require 'yaml'
require 'time'

class Timer
  attr_accessor :start, :font_dir, :font_name, :font_height, :elapsed, :config
  def initialize(options = {})
    @font_dir = options[:font_dir] || '/opt/homebrew/Cellar/toilet/0.3/share/figlet'
    @font_name = options[:font_name] || 'smmono9'
    @font_height = options[:font_height] || 8
    @elapsed = 0
    load_config
  end

  def self.run(options = {})
    self.new(options).run
  end

  def run
    return unless log_exists
    start_time
    print_time
    while running
      measure_elapsed
      print_time
    end
    print "\e[1F"
    puts time_string unless elapsed == 0
  end

  private

  def start_time
    lines = File.readlines(log_path)
    if lines.empty?
      @start = Time.now
    else
      @start = Time.parse(lines.first)
      measure_elapsed
    end
    system "clear"
  end

  def print_time
    print "\e[#{font_height}F"
    system "figlet -f #{font_name} -d #{font_dir} \"#{time_string}\""
  end

  def time_string
    data = time_data
    "#{data[:hours]}:#{data[:minutes]}:#{data[:seconds]}.#{data[:hundredths]}"
  end

  def measure_elapsed
    self.elapsed = Time.now - start
  end

  def time_data
    {
      hundredths: (elapsed % 1 * 100).floor.to_s.rjust(2,"0"),
      seconds: (elapsed.floor % 60).to_s.rjust(2,"0"),
      minutes: ((elapsed.floor % 3600) / 60).to_s.rjust(2,"0"),
      hours: (elapsed.floor / 3600).to_s.rjust(2,"0")
    }
  end

  def load_config
    if File.exists?(File.expand_path('../.advent_config.yml', __dir__))
      @config = YAML.load_file(File.expand_path('../.advent_config.yml', __dir__))
    else
      @config = {}
    end
  end

  def log_path
    root_path = File.expand_path('../', File.path(__dir__))
    File.join(root_path, config['directory'], 'log.csv')
  end

  def log_exists
    File.exists?(log_path)
  end


  def running
    lines = File.readlines(log_path)
    !(lines.last =~ /END/ || lines.empty?)
  end
end

Timer.run
