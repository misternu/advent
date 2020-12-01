require 'yaml'
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

desc "run ruby in entr"
task :watch do
  sh "ls #{config['directory']}/*.rb | entr -r ruby #{config['ruby']}"
end

# Run Benchmarks
desc "run the default script in a benchmark"
task time: ["time:ruby"]

desc "run benchmark on ruby script defined in config"
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
  ruby_path = "#{directory}/solution.rb"
  elixir_path = "#{directory}/elixir.exs"
  unless File.exists?(ruby_path)
    cp 'lib/template.rb', ruby_path
  end
  unless File.exists?(elixir_path)
    sh "touch #{elixir_path}"
  end
  File.open('.advent_config.yml', 'w') do |file|
    file.write("directory: #{directory}\nruby: #{ruby_path}\nelixir: #{elixir_path}")
  end
end
