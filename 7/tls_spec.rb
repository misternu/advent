require_relative 'tls'

describe TLS do
  describe '#support_abba' do
    let(:ip1) { "abba[mnop]qrst" }
    let(:ip2) { "abcd[bddb]xyyx" }
    let(:ip3) { "aaaa[qwer]tyui" }
    let(:ip4) { "ioxxoj[asdfgh]zxcvbn" }
    it 'returns true if the ip supports abba' do
      expect(TLS.support_abba(ip1)).to be true
      expect(TLS.support_abba(ip2)).to be false
      expect(TLS.support_abba(ip3)).to be false
      expect(TLS.support_abba(ip4)).to be true
    end
  end

  describe '#support_aba' do
    let(:ip1) { "aba[bab]xyz" }
    let(:ip2) { "xyx[xyx]xyx" }
    let(:ip3) { "aaa[kek]eke" }
    let(:ip4) { "zazbz[bzb]cdb" }
    it 'returns true if the ip supports aba' do
      expect(TLS.support_aba(ip1)).to be true
      expect(TLS.support_aba(ip2)).to be false
      expect(TLS.support_aba(ip3)).to be true
      expect(TLS.support_aba(ip4)).to be true
    end
  end

  describe '#abba' do
    let(:string0) { "abba" }
    let(:string1) { "pnnp" }
    let(:string2) { "abcd" }
    let(:string3) { "aaaa" }
    let(:string4) { "ioxxoj" }
    it 'returns true if the string is abba' do
      expect(TLS.abba(string0)).to be true
      expect(TLS.abba(string1)).to be true
      expect(TLS.abba(string2)).to be false
      expect(TLS.abba(string3)).to be false
      expect(TLS.abba(string4)).to be true
    end
  end
end