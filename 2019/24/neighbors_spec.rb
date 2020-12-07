require_relative '../../spec/spec_helper'
require_relative 'solution'

describe '#neighbors_r' do
  it 'returns normal neighbors at the same layer' do
    updl = [[3, 2], [4, 3], [3, 4], [2, 3]]
    expect(neighbors_r([3,3,0])).to eq updl.map { |d| d + [0] }
    expect(neighbors_r([3,3,1])).to eq updl.map { |d| d + [1] }
    expect(neighbors_r([3,3,-3])).to eq updl.map { |d| d + [-3] }
  end

  it 'returns a square from a lower layer when on the edge' do
    neighbors = [[2,1,-1], [4,0,0], [3,1,0], [2,0,0]]
    expect(neighbors_r([3,0,0]).sort).to eq neighbors.sort
  end

  it 'returns two squares from a lower layer when on a corner' do
    neighbors = [[2,1,-1], [3,2,-1], [4,1,0], [3,0,0]]
    expect(neighbors_r([4,0,0]).sort).to eq neighbors.sort
  end

  it 'returns many squares from a higher layer when on an inside edge' do
    neighbors = [[3,1,0], [4,2,0], [3,3,0], [4,0,1], [4,1,1], [4,2,1], [4,3,1], [4,4,1]]
    expect(neighbors_r([3,2,0]).sort).to eq neighbors.sort
  end
end