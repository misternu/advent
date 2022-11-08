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

desc "run script defined in config"
task :default do
  sh "ruby #{config['directory']}#{config['ruby']}"
end

task "run ruby script defined in config"
task :ruby do
  sh "ruby #{config['directory']}#{config['ruby']}"
end

desc "run elixir script defined in config"
task :elixir do
  sh "elixir #{config['directory']}#{config['elixir']}"
end

desc "run golang script defined in config"
task :golang do
  sh "go run #{config['directory']}#{config['golang']}"
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
  sh "ls #{config['directory']}/*.rb | entr -r rspec #{config['directory']}"
end

desc "run year spec in entr"
task :spec_year do
  p config['year']
  sh "ls #{config['year']}/lib/*.rb | entr -r rspec #{config['year']}/spec"
end

desc "run the default script in a benchmark"
task time: ["time:ruby"]

desc "timed script run"
namespace :time do
  desc "run the ruby script in a benchmark"
  task :ruby do
    sh "time ruby #{config['directory']}#{config['ruby']}"
  end

  desc "run the elixir script in a benchmark"
  task :elixir do
    sh "time elixir #{config['directory']}#{config['elixir']}"
  end
end

desc "create solution file from template and set in config"
task :create, [:directory] do |t, args|
  directory = args[:directory]
  year = args[:directory].split("/").first
  ruby_filename     = "solution.rb"
  elixir_filename   = "solution.exs"
  golang_filename   = "solution.go"
  input_filename    = "input.txt"
  sample_filename   = "sample_input.txt"
  unless File.exists?("#{directory}/#{ruby_filename}")
    cp 'lib/template.rb', "#{directory}/#{ruby_filename}"
  end
  [elixir_filename, golang_filename, input_filename, sample_filename].each do |filename|
    unless File.exists?("#{directory}/#{filename}")
      sh "touch #{directory}/#{filename}"
    end
  end
  File.open('.advent_config.yml', 'w') do |file|
    file.write("year: '#{year}'\ndirectory: #{directory}/\nruby: #{ruby_filename}\nelixir: #{elixir_filename}\ngolang: #{golang_filename}")
  end
end

# Create config file if one does not exist
desc "create config file with default values or argument"
task :config, [:directory] do |t, args|
  directory = args[:directory] || "2016/01"
  year = directory.split("/").first
  ruby_filename     = "solution.rb"
  elixir_filename   = "solution.exs"
  golang_filename   = "solution.go"
  File.open('.advent_config.yml', 'w') do |file|
    file.write("year: '#{year}'\ndirectory: #{directory}/\nruby: #{ruby_filename}\nelixir: #{elixir_filename}\ngolang: #{golang_filename}")
  end
end
