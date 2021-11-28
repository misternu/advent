require_relative 'deck'
require_relative 'instruction_parser'

example_1 = [
  "deal with increment 7",
  "deal into new stack",
  "deal into new stack",
]

example_1_solutions = %w(0 3 6 9 2 5 8 1 4 7).map(&:to_i)

example_2 = [
  "cut 6",
  "deal with increment 7",
  "deal into new stack",
]

example_2_solutions = %w(3 0 7 4 1 8 5 2 9 6).map(&:to_i)

example_3 = [
  "deal with increment 7",
  "deal with increment 9",
  "cut -2",
]

example_3_solutions = %w(6 3 0 7 4 1 8 5 2 9).map(&:to_i)

example_4 = [
  "deal into new stack",
  "cut -2",
  "deal with increment 7",
  "cut 8",
  "cut -4",
  "deal with increment 7",
  "cut 3",
  "deal with increment 9",
  "deal with increment 3",
  "cut -1",
]

example_4_solutions = %w(9 2 5 8 1 4 7 0 3 6).map(&:to_i)

describe Deck do
  context 'increment 7' do
    let(:deck) { Deck.new(10, increment: 7) }

    it 'deals with increment' do
      (0..9).each do |n|
        expect(deck.index_of(n)).to be example_1_solutions.index(n)
      end
    end
  end

  context 'offset -7' do
    let(:deck) { Deck.new(10, offset: -7) }
    let(:offset_7_deck) { %w(7 8 9 0 1 2 3 4 5 6).map(&:to_i) }

    it 'deals with offset' do
      (0..9).each do |n|
        expect(deck.index_of(n)).to be offset_7_deck.index(n)
      end
    end
  end

  context 'increment 3, offset 1' do
    let(:deck) { Deck.new(10, increment: 3, offset: 1) }

    it 'deals the example 2 deck' do
      (0..9).each do |n|
        expect(deck.index_of(n)).to be example_2_solutions.index(n)
      end
    end
  end
end

describe InstructionParser do
  context 'example 1' do
    let(:parsed_example_1) { [[7, 0], [-1, -1], [-1, -1]] }
    it 'parses the instructions' do

      expect(InstructionParser.parse(example_1)).to eq parsed_example_1
    end
  end

  context 'example 2' do
    let(:parsed_example_2) { [[1, -6], [7, 0], [-1, -1]] }
    it 'parses the instructions' do

      expect(InstructionParser.parse(example_2)).to eq parsed_example_2
    end
  end

  context 'example 3' do
    let(:parsed_example_3) { [[7, 0], [9, 0], [1, 2]] }
    it 'parses the instructions' do

      expect(InstructionParser.parse(example_3)).to eq parsed_example_3
    end
  end

  context 'example 4' do
    let(:parsed_example_4) { [[-1, -1], [1, 2], [7, 0], [1, -8], [1, 4], [7, 0], [1, -3], [9, 0], [3, 0], [1, 1]] }
    it 'parses the instructions' do

      expect(InstructionParser.parse(example_4)).to eq parsed_example_4
    end
  end
end

describe 'naive operation' do
  context 'example 1' do
    let(:instructions) { InstructionParser.parse(example_1) }
    let(:deck) { Deck.new(10) }

    it 'shuffles the deck correctly' do
      instructions.each do |technique|
        deck.apply(technique)
      end
      (0..9).each do |n|
        expect(deck.index_of(n)).to be example_1_solutions.index(n)
      end
    end
  end
  context 'example 2' do
    let(:instructions) { InstructionParser.parse(example_2) }
    let(:deck) { Deck.new(10) }

    it 'shuffles the deck correctly' do
      instructions.each do |technique|
        deck.apply(technique)
      end
      (0..9).each do |n|
        expect(deck.index_of(n)).to be example_2_solutions.index(n)
      end
    end
  end
  context 'example 3' do
    let(:instructions) { InstructionParser.parse(example_3) }
    let(:deck) { Deck.new(10) }

    it 'shuffles the deck correctly' do
      instructions.each do |technique|
        deck.apply(technique)
      end
      (0..9).each do |n|
        expect(deck.index_of(n)).to be example_3_solutions.index(n)
      end
    end
  end
  context 'example 4' do
    let(:instructions) { InstructionParser.parse(example_4) }
    let(:deck) { Deck.new(10) }

    it 'shuffles the deck correctly' do
      instructions.each do |technique|
        deck.apply(technique)
      end
      (0..9).each do |n|
        expect(deck.index_of(n)).to be example_4_solutions.index(n)
      end
    end
  end
end
