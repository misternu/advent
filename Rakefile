require 'yaml'
config = YAML.load_file(File.join(File.path(__dir__), '.advent_config.yml'))

desc "run script defined in config"
task :default do
  sh "ruby #{config['script']}"
end

desc "run benchmark on script defined in config"
task :time do
  sh "time ruby #{config['script']}"
end

desc "create directory and copy solution.rb from lib/template.rb"
task :create, [:directory] do |t, args|
  directory = args[:directory]
  mkdir_p directory
  unless File.exists?("#{directory}/solution.rb")
    cp 'lib/template.rb', "#{directory}/solution.rb"
  end
end