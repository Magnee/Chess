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
  end

  describe "#get_player" do
    it "sets the current player" do
      game = Game.new
      game.instance_variable_set(:@turn, 7)
      game.update_player
      expect(game.instance_variable_get(:@player)).to eql("white")
    end
    it "sets the current opponent" do
      game = Game.new
      game.instance_variable_set(:@turn, 7)
      game.update_player
      expect(game.instance_variable_get(:@opponent)).to eql("black")
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

  describe "#get_player_options" do
    it "returns an array of all legal move-options available to the current player" do
      game = Game.new
      expect(game.get_player_options.length).to eql(20)
    end
    it "returns an array of all legal move-options available to a given player" do
      game = Game.new
      expect(game.get_player_options("black")[0]).to eql([game.instance_variable_get(:@black_knight1), [[1, 7], [2, 5]]])
    end
  end

  describe "#get_player_hit_options" do
    it "returns an array of all current legal moves that are also hits" do
      game = Game.new
      game.instance_variable_set(:@silent, true)
      game.capture([0, 1])
      game.capture([0, 6])
      expect(game.get_player_hit_options[0]).to eql([game.instance_variable_get(:@white_rook1), [[0, 0], [0, 7]]])
    end
    it "returns an empty array if no hits are possible for the current player" do
      game = Game.new
      expect(game.get_player_hit_options).to eql([])
    end
  end

  describe "#check?" do
    game = true
    before(:each) do
      game = Game.new
      game.instance_variable_set(:@silent, true)
      game.capture([4, 6])
      game.capture([4, 1])
    end
    it "returns true if the given player king is in check" do
      queen = game.instance_variable_get(:@white_queen)
      game.make_move(queen, [[3, 0], [4, 1]])
      expect(game.check?("black")).to eql(true)
    end
    it "returns false if no king is in check" do
      expect(game.check?("white")).to eql(false)
    end
    it "returns false if the given king is not in check but the enemy king is" do
      queen = game.instance_variable_get(:@white_queen)
      game.make_move(queen, [[3, 0], [4, 1]])
      expect(game.check?("white")).to eql(false)
    end
    it "works if called in the attackers turn" do
      game.instance_variable_set(:@turn, 3)
      game.update_player
      queen = game.instance_variable_get(:@white_queen)
      game.make_move(queen, [[3, 0], [4, 1]])
      expect(game.check?("black")).to eql(true)
    end
    it "works if called in the defenders turn" do
      game.instance_variable_set(:@turn, 4)
      game.update_player
      queen = game.instance_variable_get(:@white_queen)
      game.make_move(queen, [[3, 0], [4, 1]])
      expect(game.check?("black")).to eql(true)
    end
  end

  describe "#mate?" do
    it "returns true if the given player has no moves that don't result in check" do
      game = Game.new
      game.load_game("spec/rspec_mate.txt")
      expect(game.mate?"black").to eql(true)
    end
  end


end
