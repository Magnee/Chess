require "./lib/chess_board"
require "./lib/chess_pieces"
require "./lib/game.rb"

RSpec.describe ChessBoard do

  describe "#empty_square" do
    it "clears the art of a given position" do
      board = ChessBoard.new
      board.instance_variable_set(:@board, [
        ["  ", "  ", "  ", "  "],
        ["  ", "  ", "  ", "  "],
        ["  ", "  ", "  ", "  "],
        ["  ", "  ", "  ", "\u2654 "]
        ])
      board.empty_square([3, 3])
      expect(board.instance_variable_get(:@board)[3][3]).to eql("  ")
    end
  end

  describe "#place_piece" do
    it "places a piece's art on the board at it's current position" do
      board = ChessBoard.new
      king = King.new([3, 3])
      board.place_piece(king)
      expect(board.instance_variable_get(:@board)[3][3]).to eql("\u2654 ")
    end
  end














end
