require 'digest'

class PasswordGenerator
  def generate(room)
    digest = Digest::MD5.new.update(room)
    password = Array.new(8)
    i = 1
    while true
      hex = digest.dup.update(i.to_s).hexdigest
      if hex[0..4] == "00000"
        j = hex[5].to_i(16)
        password[j] ||= hex[6] if j < 8
        p hex
        p password
        return password.join if password.compact.length == 8
      end
      i += 1
    end
  end
end