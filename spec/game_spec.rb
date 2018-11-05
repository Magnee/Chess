require "./lib/chess_board"
require "./lib/chess_pieces"
require "./lib/game.rb"

RSpec.describe Game do

  describe "#initialize" do
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

  describe "#get_player_coords" do
    it "returns an array of board coordinates" do
      game = Game.new
      $stdin.stub(gets: "d4")
      expect(game.get_player_coords).to eql([3, 3])
    end
    it "can handle unexpected input" do
      game = Game.new
      $stdin.stub(gets: "apple")
      $stdin.stub(gets: 1)
      $stdin.stub(gets: "d4")
      expect(game.get_player_coords).to eql([3, 3])
    end
  end


end
