require_relative 'spec_helper'
require_relative '../lib/auto_parser'

describe AutoParser do
  describe '#parse' do
    context 'file has one line and no commas' do
      let(:file) { File.open("#{RSPEC_ROOT}/inputs/word.txt").readlines }

      it 'returns a string if the file has one line with no comma separations' do
        expect(AutoParser.parse(file)).to be_a(String)
      end
    end

    context 'file has many lines of integers' do
      let(:file) { File.open("#{RSPEC_ROOT}/inputs/line_separated_numbers.txt").readlines }

      it 'returns an array of integers' do
        output = AutoParser.parse(file)
        expect(output).to be_an(Array)
        expect(output).to all (be_an(Integer))
      end
    end

    context 'file has many lines of words' do
      let(:file) { File.open("#{RSPEC_ROOT}/inputs/line_separated_words.txt").readlines }

      it 'returns an array of strings' do
        output = AutoParser.parse(file)
        expect(output).to be_an(Array)
        expect(output).to all (be_a(String))
      end
    end

    context 'file has many comma separated numbers' do
      let(:file) { File.open("#{RSPEC_ROOT}/inputs/comma_separated_integers.txt").readlines }

      it 'returns an array of strings' do
        output = AutoParser.parse(file)
        expect(output).to be_an(Array)
        expect(output).to all (be_an(Integer))
      end
    end

    context 'file has many lines of word groups' do
      let(:file) { File.open("#{RSPEC_ROOT}/inputs/line_separated_word_groups.txt").readlines }

      it 'returns an array of strings' do
        output = AutoParser.parse(file)
        expect(output).to be_an(Array)
        expect(output).to all (be_an(Array))
        expect(output.first).to all(be_a(String))
      end
    end

    context 'file is a map' do
      let(:file) { File.open("#{RSPEC_ROOT}/inputs/map.txt").readlines }

      it 'returns an array of strings' do
        output = AutoParser.parse(file, map: true)
        expect(output.first).to eq file.first.chomp.split('')
      end
    end
  end
end