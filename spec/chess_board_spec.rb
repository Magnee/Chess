require "./lib/chess_board"

RSpec.describe ChessBoard do


  describe "#legal_position?" do
    it "returns true for a position on the board" do
      board = ChessBoard.new
      expect(board.legal_position?([3, 4])).to eql(true)
    end
    it "returns false for a position off the board" do
      board = ChessBoard.new
      expect(board.legal_position?([6, 9])).to eql(false)
    end
  end












end
