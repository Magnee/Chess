require "./lib/chess_board"
require "./lib/chess_pieces"
require "./lib/game.rb"

RSpec.describe Game do

  describe "#setup" do
    it "creates a white King at its starting position" do
      game = Game.new
      expect(game.instance_variable_get(:@white_king).position).to eql([4, 0])
    end
    it "creates a black Queen at its starting position" do
      game = Game.new
      expect(game.instance_variable_get(:@black_queen).position).to eql([3, 7])
    end
    it "places the pieces on the board" do
      game = Game.new
      expect(game.instance_variable_get(:@game_board).instance_variable_get(:@board)[0][4]).to eql("\u2654 ")
    end
  end

  describe "#get_player" do
    it "returns the current player (white / black)" do
      game = Game.new
      game.instance_variable_set(:@turn, 7)
      expect(game.get_player).to eql("white")
    end
  end

  describe "#get_piece" do
    it "returns the piece at the given location" do
      game = Game.new
      expect(game.get_piece([3, 6])).to eql(game.instance_variable_get(:@black_pawn4))
    end
  end

  describe "#blocked_path?" do
    it "returns true if the path of a move contains another piece" do
      game = Game.new
      king = King.new([3, 3])
      queen = Queen.new([1, 1])
      game.instance_variable_set(:@pieces, [king, queen])
      path = queen.get_path([5, 5])
      expect(game.blocked_path?(path)).to eql(true)
    end
  end

  describe "#evaluate_move" do
    it "warns if the player attempts to move an enemy piece" do
      game = Game.new
      game.instance_variable_set(:@turn, 1)
      expect(game.evaluate_move([0, 6], [0, 5])).to include("can't move other player's piece, ")
    end
    it "warns if the target is a piece owned by the player" do
      game = Game.new
      game.instance_variable_set(:@turn, 1)
      expect(game.evaluate_move([0, 0], [0, 1])).to include("can't hit own piece, ")
    end
    it "warns if attempting to move off the board" do
      game = Game.new
      expect(game.evaluate_move([0, 0], [0, -1])).to include("can't move of the board, ")
    end
    it "warns if attempting the wrong move for the piece" do
      game = Game.new
      expect(game.evaluate_move([0, 1], [1, 3])).to include("piece doesn't move that way, ")
    end
    it "warns if the move is blocked" do
      game = Game.new
      expect(game.evaluate_move([0, 0], [0, 3])).to include("that path is blocked, ")
    end
    it "ignores path blocking for knights" do
      game = Game.new
      expect(game.evaluate_move([1, 0], [0, 2])).not_to include("that path is blocked, ")
    end
  end

=begin
  describe "#play_round" do
    it "increments the turn" do
      game = Game.new
      game.play_round
      expect(game.instance_variable_get(:@turn)).to eql(1)
    end
  end
=end




end
