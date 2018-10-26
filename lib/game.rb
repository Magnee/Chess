require_relative "chess_board"
require_relative "chess_pieces"

class Game
  attr_accessor :game_board

  def initialize
    setup
  end

  def setup
    @game_board = ChessBoard.new
    @white_king = King.new([4, 0])
    @white_queen = Queen.new([3, 0])
    @white_rook1 = Rook.new([0, 0])
    @white_rook2 = Rook.new([7, 0])
    @white_bishop1 = Bishop.new([2, 0])
    @white_bishop2 = Bishop.new([5, 0])
    @white_knight1 = Knight.new([1, 0])
    @white_knight2 = Knight.new([6, 0])
    @white_pawn1 = Pawn.new([0, 1])
    @white_pawn2 = Pawn.new([1, 1])
    @white_pawn3 = Pawn.new([2, 1])
    @white_pawn4 = Pawn.new([3, 1])
    @white_pawn5 = Pawn.new([4, 1])
    @white_pawn6 = Pawn.new([5, 1])
    @white_pawn7 = Pawn.new([6, 1])
    @white_pawn8 = Pawn.new([7, 1])
    @black_king = King.new([4, 7], "black")
    @black_queen = Queen.new([3, 7], "black")
    @black_rook1 = Rook.new([0, 7], "black")
    @black_rook2 = Rook.new([7, 7], "black")
    @black_bishop1 = Bishop.new([2, 7], "black")
    @black_bishop2 = Bishop.new([5, 7], "black")
    @black_knight1 = Knight.new([1, 7], "black")
    @black_knight2 = Knight.new([6, 7], "black")
    @black_pawn1 = Pawn.new([0, 6], "black")
    @black_pawn2 = Pawn.new([1, 6], "black")
    @black_pawn3 = Pawn.new([2, 6], "black")
    @black_pawn4 = Pawn.new([3, 6], "black")
    @black_pawn5 = Pawn.new([4, 6], "black")
    @black_pawn6 = Pawn.new([5, 6], "black")
    @black_pawn7 = Pawn.new([6, 6], "black")
    @black_pawn8 = Pawn.new([7, 6], "black")
    @pieces = [@white_king, @white_queen, @white_rook1, @white_rook2,
      @white_bishop1, @white_bishop2, @white_knight1, @white_knight2,
      @white_pawn1, @white_pawn2, @white_pawn3, @white_pawn4,
      @white_pawn5, @white_pawn6, @white_pawn7, @white_pawn8,
      @black_king, @black_queen, @black_rook1, @black_rook2,
      @black_bishop1, @black_bishop2, @black_knight1, @black_knight2,
      @black_pawn1, @black_pawn2, @black_pawn3, @black_pawn4,
      @black_pawn5, @black_pawn6, @black_pawn7, @black_pawn8]
    @game_board.place_piece(*@pieces)
  end


end


#eof
