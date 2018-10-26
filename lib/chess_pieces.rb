class ChessPiece
  attr_reader :color
  attr_accessor :position

  def initialize(color = "white")
    @color = color
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
    @moves = [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]]
  end
end

class Queen < ChessPiece
  def initialize
    @moves = []
    -7.upto(7) { |m| @moves << [m, 0] << [0, m] << [m, m] << [m, -m]}
  end
end

class Rook < ChessPiece
  def initialize
    @moves = []
    -7.upto(7) { |m| @moves << [m, 0] << [0, m] }
  end
end

class Bishop < ChessPiece
  def initialize
    @moves = []
    -7.upto(7) { |m| @moves << [m, m] << [m, -m]}
  end
end

class Knight < ChessPiece
  def initialize
    @moves = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]
  end
end

class Pawn < ChessPiece
  def initialize(color = "white")
    @color = color
    @moves = @color == "white" ? @moves = [[0, 1]] : @moves = [[0, -1]]
  end
end









#oef
