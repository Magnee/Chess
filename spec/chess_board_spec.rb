require "./lib/chess_board"
require "./lib/chess_pieces"
require "./lib/game.rb"

RSpec.describe ChessBoard do

  describe "#place_piece" do
    it "updates the board to a piece's current position" do
      board = ChessBoard.new
      king = King.new([3, 3])
      board.place_piece(king)
      expect(board.instance_variable_get(:@board)[3][3]).to eql("\u2654 ")
    end
  end

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
