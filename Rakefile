require 'yaml'
config = YAML.load_file(File.join(File.path(__dir__), '.advent_config.yml'))

task :default do
  sh "ruby #{config['script']}"
end

task :time do
  sh "time ruby #{config['script']}"
end