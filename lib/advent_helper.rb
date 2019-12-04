require_relative './csv_helper.rb'

class AdventHelper
  include CSVHelpers

  def initialize(options = {})
    @script_root = options.fetch(:script_root, root_dir)
  end

  private

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