require_relative "chess_board"
require_relative "chess_pieces"

class Game
  attr_accessor :game_board, :turn
  attr_reader :pieces, :player

  def initialize
    setup
    @turn = 0
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

  def get_player
    @player = turn%2 != 0 ? "white" : "black"
  end

  def get_piece(location)
    @pieces.each do |piece|
      return piece if piece.position == location
    end
    nil
  end

  def blocked_path?(path_array)
    path_array.each do |step|
      return true if get_piece(step)
    end
    false
  end

  def evaluate_move(start, finish)
    piece = get_piece(start)
    target = get_piece(finish)
    comment = ""
    if piece.color != get_player
      comment += "can't move other player's piece, "
    end
    if target != nil && target.color == get_player
      comment += "can't hit own piece, "
    end
    if @game_board.legal_position?(finish) == false
      comment += "can't move of the board, "
    end
    if piece.legal_move?(start, finish) == false
      comment += "piece doesn't move that way, "
    end
    if blocked_path?(piece.get_path(start, finish))
      comment += "that path is blocked, "
    end
    return "#{comment}"
  end

  def get_player_piece
    start = []
    puts "Player #{@player.capitalize}, select piece"
    until (0..7) === start[0]
      print "Column (a-h): "
      start[0] = ("a".."h").to_a.index(gets.chomp.downcase)
    end
    until (0..7) === start[1]
      print "Row (1-8): "
      start[1] = gets.chomp.to_i - 1
    end
    if get_piece(start) == nil
      puts "Selected empty square"
      get_player_piece
    end
    puts "Selected #{get_piece(start).color.capitalize} #{get_piece(start).type.capitalize} at #{("a".."h").to_a[start[0]]}#{start[1] + 1}"
    return get_piece(start)
  end

  def get_player_move(piece)
    finish = []
    puts "Move #{piece.color.capitalize} #{piece.type.capitalize} to?"
    until (0..7) === finish[0]
      print "Column (a-h): "
      finish[0] = ("a".."h").to_a.index(gets.chomp.downcase)
    end
    until (0..7) === finish[1]
      print "Row (1-8): "
      finish[1] = gets.chomp.to_i - 1
    end
    target = get_piece(finish) != nil ? "#{get_piece(finish).color.capitalize} #{get_piece(finish).type.capitalize}" : "empty square"
    puts "Move #{piece.color.capitalize} #{piece.type.capitalize} to #{("a".."h").to_a[finish[0]]}#{finish[1] + 1}: #{target}"
    return [piece.position, finish]
  end

  def make_move(piece, move)
    piece.move(move[0], move[1])
    @game_board.empty_square(move[0])
    @game_board.place_piece(piece)
  end

  def capture(location)
    target = get_piece(location)
    if target != nil
      puts "#{target.color.capitalize} #{target.type.capitalize} captured!"
      @pieces.delete(target)
    end
  end

  def check?
    check = false
    @pieces.each do |piece|
      if piece.color == "white" && piece.possible_targets.include?(@black_king.position)
        check = "black"
      elsif piece.color == "black" && piece.possible_targets.include?(@white_king.position)
        check = "white"
      end
    end
    puts "#{check.capitalize} King in check! " unless check == false
    check
  end


  def play_round
    @turn += 1
    get_player
    @game_board.show_board(@player)
    a = "no"
    while a != ""
      @game_board.show_board(@player) if a != "no"
      puts a if a != "no"
      piece = get_player_piece
      move = get_player_move(piece)
      a = evaluate_move(move[0], move[1])
    end
    capture(move[1])
    make_move(piece, move)
    check?
  end

  def play_game
    loop do
      play_round
    end
  end

end

  a = Game.new.play_game
#eof
