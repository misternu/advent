require_relative '../solution'

describe '#solution' do
  it 'solves the example problems for part 1' do
    expect(solution('1122')).to be 3
    expect(solution('1111')).to be 4
    expect(solution('1234')).to be 0
    expect(solution('91212129')).to be 9
  end
end

describe '#solution2' do
  it 'solves the example problems for part 2' do
    expect(solution2('1212')).to be 6
    expect(solution2('1221')).to be 0
    expect(solution2('123425')).to be 4
    expect(solution2('123123')).to be 12
    expect(solution2('12131415')).to be 4
  end
end
