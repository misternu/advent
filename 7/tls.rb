class TLS
  def self.abba(string)
    return false unless string.length > 3
    (0..string.length-4).each do |index|
      if string[index] != string[index+1]
        substring = string[index..index+3]
        return true if substring == substring.reverse
      end
    end
    false
  end

  def self.out_in(ip)
    [ip.scan(/(\]|^)(\w+)(\[|$)/).map {|x| x[1]},
     ip.scan(/\[(\w+)\]/).flatten]
  end

  def self.support_abba(ip)
    outside, inside = self.out_in(ip)
    outside.any? {|s| self.abba(s)} &&
      inside.none? {|s| self.abba(s)}
  end

  def self.support_aba(ip)
    outside, inside = self.out_in(ip)
    outside.each do |group|
      (0..group.length-3).each do |index|
        if group[index] != group[index+1] && group[index] == group[index+2]
          invert = group[index+1..index+2] + group[index+1]
          return true if inside.any? { |s| s.include?(invert) }
        end
      end
    end
    false
  end
end