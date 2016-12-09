require_relative 'password_generator'
room = File.open('input.txt').first.strip
generator = PasswordGenerator.new
p generator.generate(room)
