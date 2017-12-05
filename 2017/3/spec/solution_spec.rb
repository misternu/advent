require_relative '../solution'

describe '#solution' do
  it 'solves the sample inputs' do
    expect(solution(1)).to be 0
    expect(solution(12)).to be 3
    expect(solution(23)).to be 2
    expect(solution(1024)).to be 31
  end
end

# 147  142  133  122   59
# 304    5    4    2   57
# 330   10    1    1   54
# 351   11   23   25   26
xdescribe '#solution2' do
  it 'solves the second problem' do
    expect(solution(1)).to be 1
    expect(solution(2)).to be 1
    expect(solution(3)).to be 2
    expect(solution(4)).to be 4
    expect(solution(5)).to be 5
    expect(solution(6)).to be 10
    expect(solution(7)).to be 11
    expect(solution(8)).to be 23
    expect(solution(9)).to be 25
    expect(solution(10)).to be 26
    expect(solution(11)).to be 54
  end
end
