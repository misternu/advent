require_relative 'unjammer'

describe Unjammer do
  describe '#unjam' do
    let(:sample) {["eedadn",
                   "drvtee",
                   "eandsr",
                   "raavrd",
                   "atevrs",
                   "tsrnev",
                   "sdttsa",
                   "rasrtv",
                   "nssdts",
                   "ntnada",
                   "svetve",
                   "tesnvt",
                   "vntsnd",
                   "vrdear",
                   "dvrsen",
                   "enarar"]}
    let(:input) { File.open('input.txt').map(&:strip) }
    it 'unjams the signal' do
      expect(Unjammer.unjam(sample)).to eq "easter"
    end
    it 'passes with the input file as well' do
      expect(Unjammer.unjam(input)).to eq "bjosfbce"
    end
    it 'can also use a modified repetition code' do
      expect(Unjammer.unjam(input, {mod: true})).to eq "veqfxzfx"
    end
  end
  describe '#frequencies' do
    let(:set) { %w(a a a a a b b b b c c c)}
    let(:hash) { {"a"=>5, "b"=>4, "c"=>3} }
    it 'returns a hash of the frequencies of each occurence in the array' do
      expect(Unjammer.frequencies(set)).to eq hash
    end
  end
end