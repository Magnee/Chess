require_relative "chess_board"
require_relative "chess_pieces"

class Game
  require "json"

  attr_accessor :game_board, :turn
  attr_reader :pieces, :player

  def initialize
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
    @turn = 1
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
    if target != nil && target.color == get_player
      comment += "can't hit own piece, "
    end
    if piece.legal_move?(start, finish) == false
      comment += "piece doesn't move that way, "
    end
    if blocked_path?(piece.get_path(start, finish)) && piece.type != "knight"
      comment += "that path is blocked, "
    end
    return "#{comment}"
  end

  def get_player_coords
    print "(a1 - h8): "
    coords = $stdin.gets.chomp.split("")[0, 2]
    if coords.length == 2 && ("a".."h") === coords[0].downcase && ("0".."7") === coords[1]
      x = ("a".."h").to_a.index(coords[0])
      y = coords[1].to_i - 1
      return [x, y]
    end
    get_player_coords
  end

  def get_player_piece
    print "Player #{@player.capitalize}, select piece. "
    piece = get_piece(get_coords)
    if piece != nil && piece.color == @player
      return piece
    end
    puts "Select #{@player.capitalize} piece!"
    get_player_piece
  end

  def get_player_move(piece)
    hit = false
    print "Move #{piece.color.capitalize} #{piece.type.capitalize} to? "
    target = get_piece(get_player_coords)
    if target == nil || target.color != @player.color
      move = [piece.position, target.position]
      return move
    end
    get_player_move(piece)
  end

  def make_move(piece, move)
    print "#{piece.color.capitalize} #{piece.type.capitalize}: "
    print "#{("a".."h").to_a[move[0][0]]}#{move[0][1] + 1} to #{("a".."h").to_a[move[0][0]]}#{move[1][1] + 1}"
    piece.move_to(move[1])
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
      if piece.color == "white" && piece.possible_move_ends.include?(@black_king.position)
        check = "black"
      elsif piece.color == "black" && piece.possible_move_ends.include?(@white_king.position)
        check = "white"
      end
    end
    puts "#{check.capitalize} King in check! " unless check == false
    check
  end

  def mate?
  end

  def checkmate?
    check? && mate?
  end

  def play_round
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
      break if mate?
      @turn += 1
    end
    puts "Checkmate" if checkmate?
  end

  def serialize
    JSON.generate({
      turn: @turn,
      white_king: @white_king,
      white_quee: @white_queen,
      white_rook1: @white_rook1,
      white_rook2: @white_rook2,
      white_bishop1: @white_bishop1,
      white_bishop2: @white_bishop2,
      white_knight1: @white_knight1,
      white_knight2: @white_knight2,
      white_pawn1: @white_pawn1,
      white_pawn2: @white_pawn2,
      white_pawn3: @white_pawn3,
      white_pawn4: @white_pawn4,
      white_pawn5: @white_pawn5,
      white_pawn6: @white_pawn6,
      white_pawn7: @white_pawn7,
      white_pawn8: @white_pawn8,
      black_king: @black_king,
      black_queen: @black_queen,
      black_rook1: @black_rook1,
      black_rook2: @black_rook2,
      black_bishop1: @black_bishop1,
      black_bishop2: @black_bishop2,
      black_knight1: @black_knight1,
      black_knight2: @black_knight2,
      black_pawn1: @black_pawn1,
      black_pawn2: @black_pawn2,
      black_pawn3: @black_pawn3,
      black_pawn4: @black_pawn4,
      black_pawn5: @black_pawn5,
      black_pawn6: @black_pawn6,
      black_pawn7: @black_pawn7,
      black_pawn8: @black_pawn8
    })
  end

end
