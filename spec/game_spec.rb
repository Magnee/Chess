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

  describe "#get_piece" do
    it "returns the piece at the given location" do
      game = Game.new
      expect(game.get_piece([3, 6])).to eql(game.instance_variable_get(:@black_pawn4))
    end
  end

  describe "#is_moved_square?" do
    it "returns true if a move has been made from the given location" do
      game = Game.new
      game.instance_variable_set(:@silent, true)
      piece = game.get_piece([3, 6])
      game.make_move(piece, [[3, 6], [3, 5]])
      expect(game.is_moved_square?([3, 6])).to eql(true)
    end
    it "returns false if no move has been made from the given location" do
      game = Game.new
      game.instance_variable_set(:@silent, true)
      piece = game.get_piece([3, 6])
      game.make_move(piece, [[3, 6], [3, 5]])
      expect(game.is_moved_square?([2, 6])).to eql(false)
    end
  end

  describe "#is_blocked_path?" do
    it "returns true if the path of a move contains another piece" do
      game = Game.new
      king = King.new([3, 3])
      queen = Queen.new([1, 1])
      game.instance_variable_set(:@pieces, [king, queen])
      path = queen.get_path([5, 5])
      expect(game.is_blocked_path?(path)).to eql(true)
    end
    it "returns false for knights" do
      game = Game.new
      knight = game.get_piece([1, 0])
      path = knight.get_path([2, 2])
      expect(game.is_blocked_path?(path)).to eql(false)
    end
  end

  describe "#is_safe_move?" do
    it "returns true if the given move does not result in check for the player's king" do
      game = Game.new
      knight = game.get_piece([1, 0])
      expect(game.is_safe_move?(knight, [[1, 0], [2, 2]])).to eql(true)
    end
    it "returns false if the given move does result in check for the player's king" do
      game = Game.new
      game.instance_variable_set(:@silent, true)
      game.make_move(game.get_piece([4, 6]), [[4 ,6], [4, 5]])
      game.make_move(game.get_piece([3, 7]), [[3 ,7], [7, 3]])
      expect(game.is_safe_move?(game.get_piece([5, 1]), [[5 ,1], [5, 2]])).to eql(false)
    end
  end

  describe "#update_player" do
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
    it "returns an array of all the current player's legal moves that are also hits" do
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

  describe "#get_player_castle_options" do
    it "returns an array of all the current or given player's castling options" do
      game = Game.new
      game.instance_variable_set(:@silent, true)
      game.capture([1, 0])
      game.capture([2, 0])
      game.capture([3, 0])
      game.capture([5, 0])
      game.capture([6, 0])
      expect(game.get_player_castle_options).to eql([
        [game.instance_variable_get(:@white_king), [[4, 0], [2, 0]], game.instance_variable_get(:@white_rook1), [[0, 0], [3, 0]]],
        [game.instance_variable_get(:@white_king), [[4, 0], [6, 0]], game.instance_variable_get(:@white_rook2), [[7, 0], [5, 0]]]
      ])
    end
    it "does not allow castling if the path is blocked" do
      game = Game.new
      game.instance_variable_set(:@silent, true)
      game.capture([1, 0])
      game.capture([3, 0])
      game.capture([5, 0])
      game.capture([6, 0])
      expect(game.get_player_castle_options).to eql([
        [game.instance_variable_get(:@white_king), [[4, 0], [6, 0]], game.instance_variable_get(:@white_rook2), [[7, 0], [5, 0]]]
      ])
    end
    it "does not allow castling if the king is in check" do
      game = Game.new
      game.instance_variable_set(:@silent, true)
      game.capture([5, 0])
      game.capture([6, 0])
      game.capture([4, 1])
      game.capture([4, 6])
      game.make_move(game.get_piece([3, 7]), [[3 ,7], [4, 6]])
      expect(game.get_player_castle_options).to eql([])
    end
    it "does not allow castling if the king must move through a threatened square" do
      game = Game.new
      game.instance_variable_set(:@silent, true)
      game.capture([5, 0])
      game.capture([6, 0])
      game.capture([5, 1])
      game.capture([4, 6])
      game.make_move(game.get_piece([3, 7]), [[3 ,7], [5, 5]])
      expect(game.get_player_castle_options).to eql([])
    end
    it "does not allow castling if the king would end on a threatened square" do
      game = Game.new
      game.instance_variable_set(:@silent, true)
      game.capture([5, 0])
      game.capture([6, 0])
      game.capture([6, 1])
      game.capture([4, 6])
      game.make_move(game.get_piece([3, 7]), [[3 ,7], [6, 4]])
      expect(game.get_player_castle_options).to eql([])
    end
    it "does not allow castling if the king has moved before" do
      game = Game.new
      game.instance_variable_set(:@silent, true)
      game.capture([1, 0])
      game.capture([2, 0])
      game.capture([3, 0])
      game.capture([5, 0])
      game.capture([6, 0])
      game.make_move(game.get_piece([4, 0]), [[4 ,0], [5, 0]])
      game.make_move(game.get_piece([5, 0]), [[5 ,0], [4, 0]])
      expect(game.get_player_castle_options).to eql([])
    end
    it "does not allow castling with a rook that has moved before" do
      game = Game.new
      game.instance_variable_set(:@silent, true)
      game.capture([1, 0])
      game.capture([2, 0])
      game.capture([3, 0])
      game.capture([5, 0])
      game.capture([6, 0])
      game.make_move(game.get_piece([7, 0]), [[7 ,0], [6, 0]])
      game.make_move(game.get_piece([6, 0]), [[6 ,0], [7, 0]])
      expect(game.get_player_castle_options).to eql([
        [game.instance_variable_get(:@white_king), [[4, 0], [2, 0]], game.instance_variable_get(:@white_rook1), [[0, 0], [3, 0]]]
      ])
    end
  end

  describe "#get_player_enpassant_options" do
    it "returns an array of all the current player's en passant hit options" do
      game = Game.new
      game.instance_variable_set(:@silent, true)
      game.make_move(game.get_piece([0, 1]), [[0 ,1], [0, 3]])
      game.make_move(game.get_piece([0, 3]), [[0 ,3], [0, 4]])
      game.make_move(game.get_piece([2, 1]), [[2 ,1], [2, 3]])
      game.make_move(game.get_piece([2, 3]), [[2 ,3], [2, 4]])
      game.make_move(game.get_piece([1, 6]), [[1, 6], [1, 4]])
      expect(game.get_player_enpassant_options).to eql([
        [game.instance_variable_get(:@white_pawn1), [[0, 4], [1, 5]], [1, 4]],
        [game.instance_variable_get(:@white_pawn3), [[2, 4], [1, 5]], [1, 4]]
      ])
    end
    it "requires the target to have moved to it's current position in the last round" do
      game = Game.new
      game.instance_variable_set(:@silent, true)
      game.make_move(game.get_piece([1, 1]), [[1 ,1], [1, 3]])
      game.make_move(game.get_piece([1, 3]), [[1 ,3], [1, 4]])
      game.make_move(game.get_piece([0, 6]), [[0 ,6], [0, 4]])
      game.make_move(game.get_piece([2, 6]), [[2 ,6], [2, 4]])
      expect(game.get_player_enpassant_options).to eql([
        [game.instance_variable_get(:@white_pawn2), [[1, 4], [2, 5]], [2, 4]]
      ])
    end
    it "requires the target to have made a double-move" do
      game = Game.new
      game.instance_variable_set(:@silent, true)
      game.make_move(game.get_piece([1, 1]), [[1 ,1], [1, 3]])
      game.make_move(game.get_piece([1, 3]), [[1 ,3], [1, 4]])
      game.make_move(game.get_piece([0, 6]), [[0 ,6], [0, 5]])
      game.make_move(game.get_piece([0, 5]), [[0 ,5], [0, 4]])
      expect(game.get_player_enpassant_options).to eql([])
    end
    it "requires the target to be a pawn" do
      game = Game.new
      game.instance_variable_set(:@silent, true)
      game.make_move(game.get_piece([1, 1]), [[1 ,1], [1, 3]])
      game.make_move(game.get_piece([1, 3]), [[1 ,3], [1, 4]])
      game.capture([0, 6])
      game.make_move(game.get_piece([0, 7]), [[0 ,7], [0, 6]])
      game.make_move(game.get_piece([0, 6]), [[0 ,6], [0, 4]])
      expect(game.get_player_enpassant_options).to eql([])
    end
  end

  describe "#get_coords_input" do
    it "returns an array of board coordinates" do
      game = Game.new
      game.instance_variable_set(:@silent, true)
      $stdin.stub(gets: "d4")
      expect(game.get_coords_input).to eql([3, 3])
    end
    it "can handle unexpected input" do
      game = Game.new
      game.instance_variable_set(:@silent, true)
      $stdin.stub(gets: "apple")
      $stdin.stub(gets: 1)
      $stdin.stub(gets: "d4")
      expect(game.get_coords_input).to eql([3, 3])
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
