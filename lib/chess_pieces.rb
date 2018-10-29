class ChessPiece
  attr_reader :art, :color
  attr_accessor :position

  def legal_move?(start, finish)
    @moves.any?{ |move| start[0] + move[0] == finish[0] && start[1] + move[1] == finish[1] }
  end

  def move(start, finish)
    @position = finish if legal_move?(start, finish)
  end

  def possible_targets(start = self.position)
    targets = []
    @moves.each { |move| targets << [start[0] + move[0], start[1] + move[1]] }
    targets
  end

end




class King < ChessPiece
  def initialize(position = [0, 0], color = "white")
    @position = position
    @color = color
    @art = color == "white" ? "\u2654 " : "\u265a "
    @moves = [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]]
  end
end

class Queen < ChessPiece
  def initialize(position = [0, 0], color = "white")
    @position = position
    @color = color
    @art = color == "white" ? "\u2655 " : "\u265b "
    @moves = []
    -7.upto(7) { |m| @moves << [m, 0] << [0, m] << [m, m] << [m, -m]}
  end
end

class Rook < ChessPiece
  def initialize(position = [0, 0], color = "white")
    @position = position
    @color = color
    @art = color == "white" ? "\u2656 " : "\u265c "
    @moves = []
    -7.upto(7) { |m| @moves << [m, 0] << [0, m] }
  end
end

class Bishop < ChessPiece
  def initialize(position = [0, 0], color = "white")
    @position = position
    @color = color
    @art = color == "white" ? "\u2657 " : "\u265d "
    @moves = []
    -7.upto(7) { |m| @moves << [m, m] << [m, -m]}
  end
end

class Knight < ChessPiece
  def initialize(position = [0, 0], color = "white")
    @position = position
    @color = color
    @art = color == "white" ? "\u2658 " : "\u265e "
    @moves = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]
  end
end

class Pawn < ChessPiece
  def initialize(position = [0, 0], color = "white")
    @position = position
    @color = color
    @art = color == "white" ? "\u2659 " : "\u265f "
    if color == "white"
      @moves = @position[1] == 1 ? [[0, 1], [0, 2]] : [[0, 1]]
    else
      @moves = @position[1] == 6 ? [[0, -1], [0, -2]] : [[0, -1]]
    end
  end
end









#eof
