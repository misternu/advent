require_relative '../solution'

describe '#solution' do
  it 'solves the sample problem' do
    input = [0, 3, 0, 1, -3]
    expect(solution(input)).to be 5
  end
end

describe '#solution2' do
  it 'solves the sample problem' do
    input = [0, 3, 0, 1, -3]
    expect(solution2(input)).to be 10
  end
end
