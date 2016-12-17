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

  def new_digest(letter)
    digest.dup.update(letter)
  end

  def new_position(letter)
    case letter
    when 'U'
      [position[0]-1, position[1]]
    when 'D'
      [position[0]+1, position[1]]
    when 'L'
      [position[0], position[1]-1]
    when 'R'
      [position[0], position[1]+1]
    end
  end

  def new_moves(letter)
    moves + [letter]
  end

  def new_state(letter)
    State.new({ digest: new_digest(letter),
                position: new_position(letter),
                moves: new_moves(letter)})
  end

  def move_states
    # Dont move if you're done
    return [] if position == [3,3]
    possible = []
    possible << new_state('U') if can_move(0)
    possible << new_state('D') if can_move(1)
    possible << new_state('L') if can_move(2)
    possible << new_state('R') if can_move(3)
    possible
  end
end