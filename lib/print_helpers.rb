module PrintHelpers
  def clear
    system "clear"
  end

  def output(*values)
    stop_counter
    print_parts(*values)
    copy(*values)
  end

  def p(object)
    puts "\e[0F" + "#{object.inspect}\n\n"
  end

  def print_parts(*values)
    values.each_with_index do |v, i|
      puts "Part #{i + 1}: #{v}"
    end
  end

  def copy(*values)
    pbcopy(values.compact.last)
  end

  def pbcopy(input)
    str = input.to_s
    IO.popen('pbcopy', 'w') { |f| f << str }
    str
  end
end
