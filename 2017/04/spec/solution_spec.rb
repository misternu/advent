require_relative '../solution'

describe '#solution' do
  it 'solves the sample input' do
    input = [%w[aa bb cc dd ee],
             %w[aa bb cc dd aa],
             %w[aa bb cc dd aaa]]
    expect(solution(input)).to eq 2
  end
end

describe '#solution2' do
  it 'solves the sample input' do
    input = [%w[abcde fghij],
             %w[abcde xyz ecdab],
             %w[a ab abc abd abf abj],
             %w[iiii oiii ooii oooi oooo],
             %w[oiii ioii iioi iiio]]
    expect(solution2(input)).to eq 3
  end
end

describe '#has_no_repeats' do
  it 'can tell if there are repeats' do
    expect(has_no_repeats(%w[aa bb cc dd ee])).to be true
    expect(has_no_repeats(%w[aa bb cc dd aa])).to be false
  end
end

describe '#anagrams' do
  it 'can tell if they are anagrams of each other' do
    expect(anagrams('abcde', 'fghij')).to be false
    expect(anagrams('abcde', 'ecdab')).to be true
  end
end
