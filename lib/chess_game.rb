require_relative "chess_board"
require_relative "chess_pieces"

class Game
  require "json"

  attr_accessor :game_board, :turn, :ai
  attr_reader :pieces, :player

  def initialize
    @turn = 1
    @player = "white"
    @opponent = "black"
    @ai = false
    @silent = false
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
    @game_board = ChessBoard.new
    @game_board.place_piece(*@pieces)
    @move_log = []
  end

  def get_piece(location)
    @pieces.each{ |piece| return piece if piece.position == location }
    nil
  end

  def is_moved_square?(location)
    movedsquares = []
    @move_log.each{ |move| movedsquares << move[0] }
    movedsquares.include?(location)
  end

  def is_blocked_path?(path_array)
    path_array.each{ |step| return true if get_piece(step) }
    false
  end

  def is_safe_move?(piece, move)
    @silent = true
    File.open("lib/temp_safemove.txt", "w"){ |file| file.print serialize }
    make_move(piece, move)
    safe = check?(@player) == false ? true : false
    load_game("lib/temp_safemove.txt")
    @silent = false
    safe
  end

  def update_player
    @player = turn%2 != 0 ? "white" : "black"
    @opponent = @player == "white" ? "black" : "white"
  end

  def get_player_options(player = @player)
    possible_player_moves = []
    player_pieces = []
    @pieces.each{ |piece| player_pieces << piece if piece.color == player && piece.type != "pawn"}
    player_pieces.each do |player_piece|
      player_piece.possible_move_ends.each do |move_end|
        if (get_piece(move_end) == nil || get_piece(move_end).color != player) && is_blocked_path?(player_piece.get_path(move_end)) == false
            possible_player_moves << [player_piece, [player_piece.position, move_end]]
        end
      end
    end
    player_pawns = []
    @pieces.each{ |piece| player_pawns << piece if piece.color == player && piece.type == "pawn"}
    player_pawns.each do |pawn|
      pawn.possible_move_ends.each{ |move_end| possible_player_moves << [pawn, [pawn.position, move_end]] if get_piece(move_end) == nil }
      pawn.possible_firstmove_ends.each{ |move_end| possible_player_moves << [pawn, [pawn.position, move_end]] if pawn.color == "white" && pawn.position[1] == 1 }
      pawn.possible_firstmove_ends.each{ |move_end| possible_player_moves << [pawn, [pawn.position, move_end]] if pawn.color == "black" && pawn.position[1] == 7 }
      pawn.possible_hitmove_ends.each{ |move_end| possible_player_moves << [pawn, [pawn.position, move_end]] if get_piece(move_end) != nil && get_piece(move_end).color != player }
    end
    possible_player_moves
  end

  def get_player_hit_options(player = @player)
    possible_player_hits = get_player_options(player).select{ |threat| get_piece(threat[1][1]) != nil }
  end

  def get_player_castle_options(player = @player)
    possible_player_castlings = []
    king = player == "white" ? @white_king : @black_king
    king_start = player == "white" ? [4, 0] : [4, 7]
    king.possible_castlemove_ends.each do |move_end|
      case move_end
      when [2, 0]
        castle = @white_rook1
        castle_start = [0, 0]
        castle_end = [3, 0]
      when [6, 0]
        castle = @white_rook2
        castle_start = [7, 0]
        castle_end = [5, 0]
      when [2, 7]
        castle = @black_rook1
        castle_start = [0, 7]
        castle_end = [3, 7]
      when [6, 7]
        castle = @black_rook2
        castle_start = [7, 7]
        castle_end = [5, 7]
      end
      if is_moved_square?(king_start) == false && is_moved_square?(castle_start) == false
        if check?(player) == false && is_safe_move?(king, [king.position, king.get_path(king.position, move_end)[0]]) && is_safe_move?(king, [king.position, move_end])
          if is_blocked_path?(king.get_path(king.position, move_end)) == false && is_blocked_path?(castle.get_path(castle.position, castle_end)) == false
            possible_player_castlings << [king, [king.position, move_end], castle, [castle.position, castle_end]]
          end
        end
      end
    end
  possible_player_castlings
  end

  def get_player_enpassant_options(player = @player)
    possible_player_enpassants = []
    player_pawns = []
    @pieces.each{ |piece| player_pawns << piece if piece.color == player && piece.type == "pawn"}
    player_pawns.each do |pawn|
      pawn.possible_hitmove_ends.each do |move_end|
        hitsquare = player == "white" ? [move_end[0], move_end[1] - 1] : [move_end[0], move_end[1] + 1]
        targetstart = player == "white" ? [move_end[0], move_end[1] + 1] : [move_end[0], move_end[1] - 1]
        target = get_piece(hitsquare)
        if (player == "white" && pawn.position[1] == 4) || (player == "black" && pawn.position == 3)
          if get_piece(move_end) == nil && target != nil
            if target.color != player && target.type == "pawn"
              if  targetstart == @move_log[-1][0] && hitsquare == @move_log[-1][1]
                possible_player_enpassants << [pawn, [pawn.position, move_end], hitsquare]
              end
            end
          end
        end
      end
    end
    possible_player_enpassants
  end

  def get_random_ai_check_evasion
    File.open("lib/temp_checkevasion.txt", "w") { |file| file.print serialize }
    escapes = []
    get_player_options(@player).each do |option|
      make_move(option[0], option[1])
      escapes << option if check?(@player) == false
      load_game("lib/temp_checkevasion.txt")
    end
    escapes.sample
  end

  def get_random_ai_move
    return nil if get_player_options == []
    return get_player_options.select{ |option| is_safe_move?(option[0], option[1]) }.sample
  end

  def get_random_ai_hit
    return nil if get_player_hit_options == []
    return get_player_hit_options.select{ |option| is_safe_move?(option[0], option[1]) }.sample
  end

  def get_random_ai_castling
    return nil if get_player_castle_options == []
    return get_player_castle_options.select{ |option| is_safe_move?(option[0], option[1]) }.sample
  end

  def get_random_ai_enpassant
    return nil if get_player_enpassant_options == []
    return get_player_enpassant_options.select{ |option| is_safe_move?(option[0], option[1]) }.sample
  end

  def get_coords_input
    print "(a1 - h8): " unless @silent == true
    coords = $stdin.gets.chomp.split("")[0, 2]
    if coords.length == 2 && ("a".."h") === coords[0].downcase && ("1".."8") === coords[1]
      return [("a".."h").to_a.index(coords[0]), coords[1].to_i - 1]
    elsif coords == ["S"]
      print "Enter save name: "
      savename = gets.chomp
      save_game(savename)
    end
    print "Select a square on the board! "
    get_coords_input
  end

  def get_human_piece_choice
    print "Select piece. " unless @silent == true
    piece = get_piece(get_coords_input)
    if piece == nil || piece.color != @player
      print "Select #{@player.capitalize} piece! "
      get_human_piece_choice
    else
      return piece
    end
  end

  def get_human_move(piece)
    print "Move #{piece.color.capitalize} #{piece.type.capitalize} to? " unless @silent == true
    move = [piece.position, get_coords_input]
    target = get_piece(move[1])
    if target != nil && target.color == @player
      puts "Select empty square or enemy piece!"
      get_human_move(piece)
    elsif is_blocked_path?(piece.get_path(move[1]))
      puts "That path is blocked!"
      get_human_move(piece)
    elsif is_safe_move?(piece, move) == false
      puts "That moves threatens your King!"
      get_human_move(piece)
    elsif piece.type == "king" && get_player_castle_options.any?{ |option| option[1][1] == move[1] }
      get_player_castle_options.each { |option| return option if move[1] == option[1][1] }
    elsif piece.type != "pawn" && piece.possible_move_ends.include?(move[1]) == false
      puts "Not a valid move for this #{piece.type.capitalize}!"
      get_human_move(piece)
    elsif piece.type == "pawn" && piece.possible_move_ends.include?(move[1]) == false && piece.possible_hitmove_ends.include?(move[1]) == false && piece.possible_firstmove_ends.include?(move[1]) == false
      puts "Not a valid move for this #{piece.type.capitalize}!"
      get_human_move(piece)
    elsif piece.type == "pawn" && piece.possible_move_ends.include?(move[1]) == true && target != nil
      puts "Not a valid hit for this #{piece.type.capitalize}!"
      get_human_move(piece)
    elsif piece.type == "pawn" && get_player_enpassant_options.any?{ |option| option[1][1] == move[1] }
      get_player_enpassant_options.each { |option| return option if move[1] == option[1][1] }
    elsif piece.type == "pawn" && piece.possible_hitmove_ends.include?(move[1]) == true && target == nil
      puts "Not a valid move for this #{piece.type.capitalize}!"
      get_human_move(piece)
    elsif piece.type == "pawn" && piece.possible_firstmove_ends.include?(move[1]) == true && piece.color == "white" && piece.position[1] != 1
      puts "Not a valid move for this #{piece.type.capitalize}!"
      get_human_move(piece)
    elsif piece.type == "pawn" && piece.possible_firstmove_ends.include?(move[1]) == true && piece.color == "black" && piece.position[1] != 6
      puts "Not a valid move for this #{piece.type.capitalize}!"
      get_human_move(piece)
    elsif piece.type == "pawn" && piece.possible_firstmove_ends.include?(move[1]) == true && piece.color == "white" && piece.position[1] == 1 && target != nil
      puts "Not a valid hit for this #{piece.type.capitalize}!"
      get_human_move(piece)
    elsif piece.type == "pawn" && piece.possible_firstmove_ends.include?(move[1]) == true && piece.color == "black" && piece.position[1] == 6 && target != nil
      puts "Not a valid hit for this #{piece.type.capitalize}!"
      get_human_move(piece)
    else
      return [piece, move]
    end
  end

  def make_move(piece, move)
    print "#{piece.color.capitalize} #{piece.type.capitalize}: " unless @silent == true
    puts "#{("a".."h").to_a[move[0][0]]}#{move[0][1] + 1} to #{("a".."h").to_a[move[1][0]]}#{move[1][1] + 1}. " unless @silent == true
    capture(move[1])
    piece.move_to(move[1])
    @game_board.empty_square(move[0])
    @game_board.place_piece(piece)
    @move_log << move
  end

  def capture(location)
    target = get_piece(location)
    if target != nil
      puts "#{target.color.capitalize} #{target.type.capitalize} captured!" unless @silent == true
      @game_board.empty_square(location)
      target.position = [8, 8]
      @pieces.delete(target)
    end
  end

  def pawn_promotion
    @pieces.each do |piece|
      piece.promote if piece.type == "pawn" && piece.color == "white" && piece.position[1] == 7
      piece.promote if piece.type == "pawn" && piece.color == "black" && piece.position[1] == 0
    end
  end

  def check?(player)
    check = false
    attacker = player == "white" ? "black" : "white"
    threats = get_player_hit_options(attacker)
    threats.each do |threat|
      target = get_piece(threat[1][1])
      if target.type == "king" && target.color == player
        check = true
      end
    end
    puts "#{player.capitalize} King in check! " if check != false && @silent != true
    check
  end

  def mate?(player)
    @silent = true
    mate = true
    File.open("lib/temp_mate.txt", "w") { |file| file.print serialize }
    get_player_options(player).each do |option|
      make_move(option[0], option[1])
      mate = false if check?(player) == false
      load_game("lib/temp_mate.txt")
    end
    @silent = false
    mate
  end

  def checkmate?
    check?(@player) && mate?(@player)
  end

  def play_round
    if @player == @ai
      sleep 1
      if check?(@player) == true
        ai = get_random_ai_check_evasion
      elsif get_random_ai_enpassant != nil
        ai = get_random_ai_enpassant
        capture(ai[2])
      elsif get_random_ai_hit != nil
        ai = get_random_ai_hit
      elsif get_random_ai_castling != nil
        ai = get_random_ai_castling
        make_move(ai[2], ai[3])
      else
        ai = get_random_ai_move
      end
      make_move(ai[0], ai[1])
    else
      piece = get_human_piece_choice
      play = get_human_move(piece)
      make_move(play[2], play[3]) if play.length == 4
      make_move(play[0], play[1])
    end
    pawn_promotion
    @game_board.show_board(@player)
    sleep 1
  end

  def play_game
    @game_board.place_piece(*@pieces)
    loop do
      update_player
      @game_board.show_board(@player)
      break if mate?(@player)
      play_round
      @turn += 1
    end
    puts "Mate"
    puts "Checkmate" if checkmate?
  end

  def serialize
    JSON.generate({
      ai: @ai,
      turn: @turn,
      white_king: @white_king.position,
      white_queen: @white_queen.position,
      white_rook1: @white_rook1.position,
      white_rook2: @white_rook2.position,
      white_bishop1: @white_bishop1.position,
      white_bishop2: @white_bishop2.position,
      white_knight1: @white_knight1.position,
      white_knight2: @white_knight2.position,
      white_pawn1: [@white_pawn1.position, @white_pawn1.type],
      white_pawn2: [@white_pawn2.position, @white_pawn2.type],
      white_pawn3: [@white_pawn3.position, @white_pawn3.type],
      white_pawn4: [@white_pawn4.position, @white_pawn4.type],
      white_pawn5: [@white_pawn5.position, @white_pawn5.type],
      white_pawn6: [@white_pawn6.position, @white_pawn6.type],
      white_pawn7: [@white_pawn7.position, @white_pawn7.type],
      white_pawn8: [@white_pawn8.position, @white_pawn8.type],
      black_king: @black_king.position,
      black_queen: @black_queen.position,
      black_rook1: @black_rook1.position,
      black_rook2: @black_rook2.position,
      black_bishop1: @black_bishop1.position,
      black_bishop2: @black_bishop2.position,
      black_knight1: @black_knight1.position,
      black_knight2: @black_knight2.position,
      black_pawn1: [@black_pawn1.position, @black_pawn1.type],
      black_pawn2: [@black_pawn2.position, @black_pawn2.type],
      black_pawn3: [@black_pawn3.position, @black_pawn3.type],
      black_pawn4: [@black_pawn4.position, @black_pawn4.type],
      black_pawn5: [@black_pawn5.position, @black_pawn5.type],
      black_pawn6: [@black_pawn6.position, @black_pawn6.type],
      black_pawn7: [@black_pawn7.position, @black_pawn7.type],
      black_pawn8: [@black_pawn8.position, @black_pawn8.type],
      move_log: @move_log
    })
  end

  def save_game(savename)
    Dir.mkdir("saves") unless Dir.exists?("saves")
    savefile = "saves/#{savename}.txt"
    File.open(savefile, "w") { |file| file.print serialize }
    puts "Game '#{savename}' Saved!" unless @silent == true
  end

  def load_game(loadfile)
    game_data = JSON.parse(File.read(loadfile), {:symbolize_names => true})
    @ai = game_data[:ai]
    @turn = game_data[:turn]
    update_player
    @white_king.position = game_data[:white_king]
    @white_queen.position = game_data[:white_queen]
    @white_rook1.position = game_data[:white_rook1]
    @white_rook2.position = game_data[:white_rook2]
    @white_bishop1.position = game_data[:white_bishop1]
    @white_bishop2.position = game_data[:white_bishop2]
    @white_knight1.position = game_data[:white_knight1]
    @white_knight2.position = game_data[:white_knight2]
    @white_pawn1.position = game_data[:white_pawn1][0]
    @white_pawn2.position = game_data[:white_pawn2][0]
    @white_pawn3.position = game_data[:white_pawn3][0]
    @white_pawn4.position = game_data[:white_pawn4][0]
    @white_pawn5.position = game_data[:white_pawn5][0]
    @white_pawn6.position = game_data[:white_pawn6][0]
    @white_pawn7.position = game_data[:white_pawn7][0]
    @white_pawn8.position = game_data[:white_pawn8][0]
    @white_pawn1.promote if game_data[:white_pawn1][1] == "queen"
    @white_pawn2.promote if game_data[:white_pawn2][1] == "queen"
    @white_pawn3.promote if game_data[:white_pawn3][1] == "queen"
    @white_pawn4.promote if game_data[:white_pawn4][1] == "queen"
    @white_pawn5.promote if game_data[:white_pawn5][1] == "queen"
    @white_pawn6.promote if game_data[:white_pawn6][1] == "queen"
    @white_pawn7.promote if game_data[:white_pawn7][1] == "queen"
    @white_pawn8.promote if game_data[:white_pawn8][1] == "queen"
    @black_king.position = game_data[:black_king]
    @black_queen.position = game_data[:black_queen]
    @black_rook1.position = game_data[:black_rook1]
    @black_rook2.position = game_data[:black_rook2]
    @black_bishop1.position = game_data[:black_bishop1]
    @black_bishop2.position = game_data[:black_bishop2]
    @black_knight1.position = game_data[:black_knight1]
    @black_knight2.position = game_data[:black_knight2]
    @black_pawn1.position = game_data[:black_pawn1][0]
    @black_pawn2.position = game_data[:black_pawn2][0]
    @black_pawn3.position = game_data[:black_pawn3][0]
    @black_pawn4.position = game_data[:black_pawn4][0]
    @black_pawn5.position = game_data[:black_pawn5][0]
    @black_pawn6.position = game_data[:black_pawn6][0]
    @black_pawn7.position = game_data[:black_pawn7][0]
    @black_pawn8.position = game_data[:black_pawn8][0]
    @black_pawn1.promote if game_data[:black_pawn1][1] == "queen"
    @black_pawn2.promote if game_data[:black_pawn2][1] == "queen"
    @black_pawn3.promote if game_data[:black_pawn3][1] == "queen"
    @black_pawn4.promote if game_data[:black_pawn4][1] == "queen"
    @black_pawn5.promote if game_data[:black_pawn5][1] == "queen"
    @black_pawn6.promote if game_data[:black_pawn6][1] == "queen"
    @black_pawn7.promote if game_data[:black_pawn7][1] == "queen"
    @black_pawn8.promote if game_data[:black_pawn8][1] == "queen"
    @pieces = [@white_king, @white_queen, @white_rook1, @white_rook2,
      @white_bishop1, @white_bishop2, @white_knight1, @white_knight2,
      @white_pawn1, @white_pawn2, @white_pawn3, @white_pawn4,
      @white_pawn5, @white_pawn6, @white_pawn7, @white_pawn8,
      @black_king, @black_queen, @black_rook1, @black_rook2,
      @black_bishop1, @black_bishop2, @black_knight1, @black_knight2,
      @black_pawn1, @black_pawn2, @black_pawn3, @black_pawn4,
      @black_pawn5, @black_pawn6, @black_pawn7, @black_pawn8]
    @pieces.delete_if { |piece| piece.position == [8, 8] }
    @game_board = ChessBoard.new
    @game_board.place_piece(*@pieces)
    @move_log = game_data[:move_log]
  end

end
