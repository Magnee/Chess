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









end
