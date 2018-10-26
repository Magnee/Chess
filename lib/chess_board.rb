class ChessBoard
  attr_accessor :board

  def initialize
    @board = []
    0.upto(7) do |y|
      rank = []
      0.upto(7) do |x|
        rank << "  "
      end
      @board << rank
    end
  end

  def place_piece(*pieces)
    pieces.each do |piece|
      @board[piece.position[1]][piece.position[0]] = piece.art
    end
  end

  def show_board
    r = 8
    @board.reverse.each do |rank|
      print "\n    -- -- -- -- -- -- -- --"
      print "\n #{r} |"
      rank.each do |file|
        print "#{file}|"
      end
      r -= 1
    end
    print "\n    -- -- -- -- -- -- -- --"
    puts "\n    a  b  c  d  e  f  g  h"
  end

  def legal_position?(position)
    @board[position[1]] != nil && @board[position[1]][position[0]] != nil
  end

end
