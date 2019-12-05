require_relative '../solution'

describe '#solution' do
  it 'solves the example input' do
    input = [[5, 1, 9, 5], [7, 5, 3], [2, 4, 6, 8]]
    expect(solution(input)).to be 18
  end
end

describe '#solution2' do
  it 'solves the second sample problem' do
    input = [[5, 9, 2, 8],[9, 4, 7, 3],[3, 8, 6, 5]]
    expect(solution2(input)).to be 9
  end
end
