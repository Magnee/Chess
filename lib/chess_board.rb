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
      @board.reverse.each_with_index do |rank, i|
        print "\n    -- -- -- -- -- -- -- --"
        print "\n #{8 - i} |"
        rank.each do |file|
          print "#{file}|"
        end
      end
      print "\n    -- -- -- -- -- -- -- --"
      puts "\n    a  b  c  d  e  f  g  h \n "
    elsif player == "black"
      @board.each_with_index do |rank, i|
        print "\n    -- -- -- -- -- -- -- --"
        print "\n #{i + 1} |"
        rank.each do |file|
          print "#{file}|"
        end
      end
      print "\n    -- -- -- -- -- -- -- --"
      puts "\n    h  g  f  e  d  c  b  a \n "
    end
  end

  def legal_position?(position)
      return false if position[0] < 0 || position[1] < 0
    @board[position[1]] != nil && @board[position[1]][position[0]] != nil
  end

end
