require_relative '../../lib/advent_helper'
helper = AdventHelper.new(script_root:__dir__, script_file: __FILE__)
input = helper.send(:open_file, 'input.txt').read
passports = input.split("\n\n")
passports.map! { |passport| passport.split(/\s+/) }

requirements = %w[
  byr
  iyr
  eyr
  hgt
  hcl
  ecl
  pid
]
  # cid

# Part 1
# 245
a = passports.count do |passport|
  requirements.all? do |requirement|
    passport.map { |part| part.split(':').first } .include?(requirement)
  end
end

# Part 2
# 133
full_requirements = {
  byr: -> (string) { string.length == 4 && string.to_i >= 1920 && string.to_i <= 2002  },
  iyr: -> (string) { string.length == 4 && string.to_i >= 2010 && string.to_i <= 2020  },
  eyr: -> (string) { string.length == 4 && string.to_i >= 2020 && string.to_i <= 2030  },
  hgt: -> (string) { (string[-2..-1] == 'cm' && (150..193).include?(string[0...-2].to_i)) || (string[-2..-1] == 'in' && (59..76).include?(string[0...-2].to_i)) },
  hcl: -> (string) { /^#[0-9a-f]{6}$/ =~ string },
  ecl: -> (string) { /(amb|blu|brn|gry|grn|hzl|oth)/ =~ string },
  pid: -> (string) { /^\d{9}$/ =~ string }
}

b = passports.count do |passport|
  options = Hash[passport.map { |part| part.split(':') }]
  pid = options['pid']
  if !(/^\d{9}$/ =~ pid) && /\d{9}/ =~ pid && requirements.all? { |requirement| options[requirement] && full_requirements[requirement.to_sym].call(options[requirement]) }
    p pid
  end
  requirements.all? do |requirement|
    options[requirement] && full_requirements[requirement.to_sym].call(options[requirement])
  end
end



helper.output(a, b)
