require 'digest'

class State
  attr_reader :digest, :position, :moves
  def initialize(options = {})
    if options[:input]
      @digest = Digest::MD5.new.update(options.fetch(:input))
      @position = [0,0]
      @moves = []
    else
      @digest = options.fetch(:digest)
      @position = options.fetch(:position, [0,0])
      @moves = options.fetch(:moves, [])
    end
  end

  def off_board(direction)
    case direction
    when 0
      position[0] == 0
    when 1
      position[0] == 3
    when 2
      position[1] == 0
    when 3
      position[1] == 3
    end
  end

  def can_move(direction)
    # 0, 1, 2, 3 == up, down, left, right
    return false if off_board(direction)
    ('b'..'f').include?(digest.hexdigest[direction])
  end

  def move_states
    return [] if position == [3,3]
    possible = []
    if can_move(0)
      new_digest = digest.dup.update('U')
      new_position = [position[0]-1, position[1]]
      possible << State.new({
          digest: new_digest,
          position: new_position,
          moves: moves + ['U']
        })
    end
    if can_move(1)
      new_digest = digest.dup.update('D')
      new_position = [position[0]+1, position[1]]
      possible << State.new({
          digest: new_digest,
          position: new_position,
          moves: moves + ['D']
        })
    end
    if can_move(2)
      new_digest = digest.dup.update('L')
      new_position = [position[0], position[1]-1]
      possible << State.new({
          digest: new_digest,
          position: new_position,
          moves: moves + ['L']
        })
    end
    if can_move(3)
      new_digest = digest.dup.update('R')
      new_position = [position[0], position[1]+1]
      possible << State.new({
          digest: new_digest,
          position: new_position,
          moves: moves + ['R']
        })
    end
    possible
  end
end