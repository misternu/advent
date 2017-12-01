require_relative 'tls'

ips = File.open('input.txt').map(&:strip)

# puts ips.count { |ip| TLS.support_abba(ip) }
puts ips.count { |ip| TLS.support_aba(ip) }