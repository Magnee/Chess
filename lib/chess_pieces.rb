class ChessPiece
  attr_reader :art, :color, :type
  attr_accessor :position

  def legal_move?(start = self.position, finish)
    @moves.any?{ |move| start[0] + move[0] == finish[0] && start[1] + move[1] == finish[1] }
  end

  def legal_position?(position)
    legal = (0..7) === position[0] && (0..7) === position[1] ? true : false
  end

  def possible_move_ends(start = self.position)
    targets = []
    @moves.each do |move|
      target = [start[0] + move[0], start[1] + move[1]]
      targets << target if legal_position?(target)
    end
    targets
  end

  def get_path(start = self.position, finish)
    path = []
    move = [finish[0] - start[0], finish[1] - start[1]]
    if move[0] == 0
      if move[1] >= 0
        (1...move[1]).each { |y| path << [start[0], start[1] + y] }
      else
        (1...-move[1]).each { |y| path << [start[0], start[1] - y] }
      end
    elsif move[1] == 0
      if move[0] >= 0
        (1...move[0]).each { |x| path << [start[0] + x, start[1]] }
      else
        (1...-move[0]).each { |x| path << [start[0] - x, start[1]] }
      end
    elsif move[0] == move[1]
      if move[0] >= 0
        (1...move[0]).each { |z| path << [start[0] + z, start[1] + z] }
      else
        (1...-move[0]).each { |z| path << [start[0] - z, start[1] - z] }
      end
    elsif move[0] == -move[1]
      if move[0] >= 0
        (1...move[0]).each { |z| path << [start[0] + z, start[1] - z] }
      else
        (1...-move[0]).each { |z| path << [start[0] - z, start[1] + z] }
      end
    end
    path
  end

  def move_to(finish)
    @position = finish
  end

  def promote
    @type = "queen"
    @art = color == "white" ? "\u2655 " : "\u265b "
    @moves = []
    -7.upto(7) { |m| @moves << [m, 0] << [0, m] << [m, m] << [m, -m]}
  end

end



class King < ChessPiece
  def initialize(position = [0, 0], color = "white")
    @type = "king"
    @position = position
    @color = color
    @art = color == "white" ? "\u2654 " : "\u265a "
    @moves = [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]]
  end
end

class Queen < ChessPiece
  def initialize(position = [0, 0], color = "white")
    @type = "queen"
    @position = position
    @color = color
    @art = color == "white" ? "\u2655 " : "\u265b "
    @moves = []
    -7.upto(7) { |m| @moves << [m, 0] << [0, m] << [m, m] << [m, -m]}
  end
end

class Rook < ChessPiece
  def initialize(position = [0, 0], color = "white")
    @type = "rook"
    @position = position
    @color = color
    @art = color == "white" ? "\u2656 " : "\u265c "
    @moves = []
    -7.upto(7) { |m| @moves << [m, 0] << [0, m] }
  end
end

class Bishop < ChessPiece
  def initialize(position = [0, 0], color = "white")
    @type = "bishop"
    @position = position
    @color = color
    @art = color == "white" ? "\u2657 " : "\u265d "
    @moves = []
    -7.upto(7) { |m| @moves << [m, m] << [m, -m]}
  end
end

class Knight < ChessPiece
  def initialize(position = [0, 0], color = "white")
    @type = "knight"
    @position = position
    @color = color
    @art = color == "white" ? "\u2658 " : "\u265e "
    @moves = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]
  end
end

class Pawn < ChessPiece
  def initialize(position = [0, 0], color = "white")
    @type = "pawn"
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
