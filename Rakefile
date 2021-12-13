require 'yaml'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
  # no rspec available
end

if File.exists?('.advent_config.yml')
  config = YAML.load_file(File.join(File.path(__dir__), '.advent_config.yml'))
else
  config = {}
end

# Run Scripts
desc "run script defined in config"
task :default do
  sh "ruby #{config['ruby']}"
end

task "run ruby script defined in config"
task :ruby do
  sh "ruby #{config['ruby']}"
end

desc "run elixir script defined in config"
task :elixir do
  sh "elixir #{config['elixir']}"
end

desc "run the default script in entr"
task watch: ["watch:ruby"]

desc "watched script run"
namespace :watch do
  # TODO add error handling for when entr is not installed
  desc "run the ruby script in entr"
  task :ruby do
    sh "ls #{config['directory']}/*.rb | entr -r ruby #{config['ruby']}"
  end
  desc "run the elixir script in entr"
  task :elixir do
    sh "ls #{config['directory']}/*.exs | entr -r elixir #{config['elixir']}"
  end
end

desc "run rspec in entr"
task :spec_watch do
  sh "ls **/*.rb | entr -r rspec spec"
end

desc "run solution spec in entr"
task :spec_solution do
  p config['directory']
  sh "ls #{config['directory']}*.rb | entr -r rspec #{config['directory']}"
end

# Run Benchmarks
desc "run the default script in a benchmark"
task time: ["time:ruby"]

desc "timed script run"
namespace :time do
  desc "run the ruby script in a benchmark"
  task :ruby do
    sh "time ruby #{config['ruby']}"
  end

  desc "run the elixir script in a benchmark"
  task :elixir do
    sh "time elixir #{config['elixir']}"
  end
end

# Create solution folders and files
desc "create solution file from template and set in config"
task :create, [:directory] do |t, args|
  directory = args[:directory]
  mkdir_p directory
  ruby_path         = "#{directory}/solution.rb"
  elixir_path       = "#{directory}/elixir.exs"
  input_path        = "#{directory}/input.txt"
  sample_input_path = "#{directory}/sample_input.txt"
  unless File.exists?(ruby_path)
    cp 'lib/template.rb', ruby_path
  end
  [elixir_path, input_path, sample_input_path].each do |path|
    unless File.exists?(path)
      sh "touch #{path}"
    end
  end
  File.open('.advent_config.yml', 'w') do |file|
    file.write("directory: #{directory}\nruby: #{ruby_path}\nelixir: #{elixir_path}")
  end
end
