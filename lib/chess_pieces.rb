class ChessPiece
  attr_reader :art, :color
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
  def initialize(color = "white")
    @color = color
    @art = color == "white" ? "\u2654" : "\u265a"
    @moves = [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]]
  end
end

class Queen < ChessPiece
  def initialize(color = "white")
    @color = color
    @art = color == "white" ? "\u2655" : "\u265b"
    @moves = []
    -7.upto(7) { |m| @moves << [m, 0] << [0, m] << [m, m] << [m, -m]}
  end
end

class Rook < ChessPiece
  def initialize(color = "white")
    @color = color
    @art = color == "white" ? "\u2656" : "\u265c"
    @moves = []
    -7.upto(7) { |m| @moves << [m, 0] << [0, m] }
  end
end

class Bishop < ChessPiece
  def initialize(color = "white")
    @color = color
    @art = color == "white" ? "\u2657" : "\u265d"
    @moves = []
    -7.upto(7) { |m| @moves << [m, m] << [m, -m]}
  end
end

class Knight < ChessPiece
  def initialize(color = "white")
    @color = color
    @art = color == "white" ? "\u2658" : "\u265e"
    @moves = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]
  end
end

class Pawn < ChessPiece
  def initialize(color = "white")
    @color = color
    @art = color == "white" ? "\u2659" : "\u265f"
    @moves = color == "white" ? @moves = [[0, 1]] : @moves = [[0, -1]]
  end
end









#oef
