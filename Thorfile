module Configuration
  def config
    return @configuration if @configuration
    load_configuration
  end

  def load_configuration
    if File.exists?('.advent_config.yml')
      @configuration = YAML.load_file(File.join(File.path(__dir__), '.advent_config.yml'))
    else
      @configuration = {}
    end
  end
end

class Tasks < Thor
  include Configuration
  desc "create DIRECTORY", "create a new solution folder"
  def create(directory)
    FileUtils.mkdir_p directory
    ruby_path = "#{directory}/solution.rb"
    elixir_path = "#{directory}/elixir.exs"
    unless File.exists?(ruby_path)
      FileUtils.cp 'lib/template.rb', ruby_path
    end
    FileUtils.touch elixir_path
    File.open('.advent_config.yml', 'w') do |file|
      file.write("directory: #{directory}\nruby: #{ruby_path}\nelixir: #{elixir_path}")
    end
  end
end
