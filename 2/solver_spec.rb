require_relative 'solver'

describe 'Solver' do
  describe '#solve' do
    let(:solver) { Solver.new(["ULL", "RRDDD", "LURDL", "UUUUD"]) }
    it 'solves the example' do
      expect(solver.solve).to eq "1985"
    end
  end
  describe '#move' do
    let(:solver) { Solver.new([]) }
    it 'starts at 1,1' do
      expect(solver.position).to eq [1,1]
    end
    it 'moves up with U' do
      solver.move('U')
      expect(solver.position).to eq [1,0]
    end
    it 'moves right with R' do
      solver.move('R')
      expect(solver.position).to eq [2,1]
    end
    it 'moves down with D' do
      solver.move('D')
      expect(solver.position).to eq [1,2]
    end
    it 'moves left with L' do
      solver.move('L')
      expect(solver.position).to eq [0,1]
    end
    it 'stops at the left wall' do
      5.times do solver.move('L') end
      expect(solver.position).to eq [0,1]
    end
    it 'stops at the right wall' do
      5.times do solver.move('R') end
      expect(solver.position).to eq [2,1]
    end
    it 'stops at the upper wall' do
      5.times do solver.move('U') end
      expect(solver.position).to eq [1,0]
    end
    it 'stops at the bottom wall' do
      5.times do solver.move('D') end
      expect(solver.position).to eq [1,2]
    end
  end
  describe '#solve with a special numpad' do
    let(:solver) do
      Solver.new([], [[nil, nil, "1", nil, nil],
                      [nil, "2", "3", "4", nil],
                      ["5", "6", "7", "8", "9"],
                      [nil, "A", "B", "C", nil],
                      [nil, nil, "D", nil, nil]])
    end
    it 'starts at 0,2' do
      expect(solver.position).to eq [0,2]
    end
    it 'can only move right at first' do
      solver.move('U')
      expect(solver.position).to eq [0,2]
      solver.move('L')
      expect(solver.position).to eq [0,2]
      solver.move('D')
      expect(solver.position).to eq [0,2]
      solver.move('R')
      expect(solver.position).to eq [1,2]
    end
    it 'can then move up and down' do
      solver.move('R')
      solver.move('U')
      solver.move('U')
      expect(solver.position).to eq [1,1]
      solver.move('D')
      solver.move('D')
      solver.move('D')
      expect(solver.position).to eq [1,3]
    end
  end
end