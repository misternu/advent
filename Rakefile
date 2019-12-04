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

desc "create solution file from template and set in config"
task :create, [:directory] do |t, args|
  directory = args[:directory]
  mkdir_p directory
  file_path = "#{directory}/solution.rb"
  unless File.exists?("#{directory}/solution.rb")
    cp 'lib/template.rb', "#{directory}/solution.rb"
  end
  File.open('.advent_config.yml', 'w') do |file|
    file.write("script: #{file_path}")
  end
end

desc "set solution in config"
task :solution, [:path] do |t, args|
  file_path = args[:path]
  puts "Setting config to #{file_path}"
  File.open('.advent_config.yml', 'w') do |file|
    file.write("script: #{file_path}")
  end
end