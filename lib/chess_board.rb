class ChessBoard
  attr_accessor :board
  Empty = "  "

  def initialize
    @board = []
    0.upto(7) do |y|
      rank = []
      0.upto(7) do |x|
        rank << Empty
      end
      @board << rank
    end
  end

  def empty_square(*positions)
    positions.each do |position|
      @board[position[1]][position[0]] = Empty
    end
  end

  def place_piece(*pieces)
    pieces.each do |piece|
      @board[piece.position[1]][piece.position[0]] = piece.art
    end
  end

  def show_board(player)
    if player == "white"
      print "\n   \u250c\u2500\u2500\u252c\u2500\u2500\u252c\u2500\u2500\u252c\u2500\u2500\u252c\u2500\u2500\u252c\u2500\u2500\u252c\u2500\u2500\u252c\u2500\u2500\u2510"
      @board.reverse.each_with_index do |rank, i|
        print "\n   \u251c\u2500\u2500\u253c\u2500\u2500\u253c\u2500\u2500\u253c\u2500\u2500\u253c\u2500\u2500\u253c\u2500\u2500\u253c\u2500\u2500\u253c\u2500\u2500\u2524" if i > 0
        print "\n #{8 - i} \u2502"
        rank.each do |file|
          print "#{file}\u2502"
        end
      end
      print "\n   \u2514\u2500\u2500\u2534\u2500\u2500\u2534\u2500\u2500\u2534\u2500\u2500\u2534\u2500\u2500\u2534\u2500\u2500\u2534\u2500\u2500\u2534\u2500\u2500\u2518"
      puts "\n    a  b  c  d  e  f  g  h \n "
      puts "Player White"
    elsif player == "black"
      print "\n   \u250c\u2500\u2500\u252c\u2500\u2500\u252c\u2500\u2500\u252c\u2500\u2500\u252c\u2500\u2500\u252c\u2500\u2500\u252c\u2500\u2500\u252c\u2500\u2500\u2510"
      @board.each_with_index do |rank, i|
        print "\n   \u251c\u2500\u2500\u253c\u2500\u2500\u253c\u2500\u2500\u253c\u2500\u2500\u253c\u2500\u2500\u253c\u2500\u2500\u253c\u2500\u2500\u253c\u2500\u2500\u2524" if i > 0
        print "\n #{i + 1} \u2502"
        rank.reverse.each do |file|
          print "#{file}\u2502"
        end
      end
      print "\n   \u2514\u2500\u2500\u2534\u2500\u2500\u2534\u2500\u2500\u2534\u2500\u2500\u2534\u2500\u2500\u2534\u2500\u2500\u2534\u2500\u2500\u2534\u2500\u2500\u2518"
      puts "\n    h  g  f  e  d  c  b  a \n "
      puts "Player Black"
    end
  end


end
