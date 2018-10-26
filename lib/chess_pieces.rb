class ChessPiece
  attr_reader :color
  attr_accessor :position

  def initialize
  end

  def legal_move?(start, finish)
    legal = false
    @moves.each do |move|
      if start[0] + move[0] == finish[0] && start[1] + move[1] == finish[1]
        legal = true
      end
    end
    legal
  end

  def move(start, finish)
    @position = finish if legal_move?(start, finish)
  end

end


class King < ChessPiece

  def initialize
    @moves = [[0,1], [1,1], [1,0], [1,-1], [0,-1], [-1,-1], [-1, 0], [-1,1]]
  end

end
