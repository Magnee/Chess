require "./lib/chess_pieces"

RSpec.describe ChessPiece do

  describe "#legal_move?" do
    it "returns true for a legal move for the calling piece" do
      piece = King.new
      expect(piece.legal_move?([3,3], [4,4])).to eql(true)
    end
    it "returns false for an illegal move for the calling piece" do
      piece = King.new
      expect(piece.legal_move?([3,3], [4,5])).to eql(false)
    end
  end

  describe "#legal_position?" do
    it "returns true for a legal position" do
      piece = King.new
      expect(piece.legal_position?([3, 4])).to eql(true)
    end
    it "returns false for an illegal position" do
      piece = King.new
      expect(piece.legal_position?([1, -1])).to eql(false)
    end
    it "can handle weird input" do
      piece = King.new
      expect(piece.legal_position?("apple")).to eql(false)
    end

  end

  describe "#possible_move_ends" do
    it "returns an array of positions the piece can make a move to" do
      king = King.new([3, 3])
      expect(king.possible_move_ends([3, 3])).to eql([[3, 4], [4, 4], [4, 3], [4, 2], [3, 2], [2, 2], [2, 3], [2, 4]])
    end
    it "uses a piece's current position as start if none is given" do
      king = King.new([3, 3])
      expect(king.possible_move_ends).to eql([[3, 4], [4, 4], [4, 3], [4, 2], [3, 2], [2, 2], [2, 3], [2, 4]])
    end
    it "excludes illegal positions" do
      king = King.new([0, 0])
      expect(king.possible_move_ends).to eql([[0, 1], [1, 1], [1, 0]])
    end
  end

  describe "#get_path" do
    it "returns an array of the spaces passed on a move from start to finish" do
      queen = Queen.new([1, 1])
      expect(queen.get_path([4, 4])).to eql([[2, 2], [3, 3]])
    end
    it "works on horizontal movements" do
      queen = Queen.new([3, 3])
      expect(queen.get_path([6, 3])).to eql([[4, 3], [5, 3]])
    end
    it "works on vertical movements" do
      queen = Queen.new([3, 3])
      expect(queen.get_path([3, 6])).to eql([[3, 4], [3, 5]])
    end
    it "works on diagonal movements" do
      queen = Queen.new([3, 3])
      expect(queen.get_path([6, 6])).to eql([[4, 4], [5, 5]])
    end
    it "works on cross-diagonal movements" do
      queen = Queen.new([3, 3])
      expect(queen.get_path([6, 0])).to eql([[4, 2], [5, 1]])
    end
    it "handles negative horizontal movements" do
      queen = Queen.new([3, 3])
      expect(queen.get_path([0, 3])).to eql([[2, 3], [1, 3]])
    end
    it "handles negative vertical movements" do
      queen = Queen.new([3, 3])
      expect(queen.get_path([3, 0])).to eql([[3, 2], [3, 1]])
    end
    it "handles negative diagonal movements" do
      queen = Queen.new([3, 3])
      expect(queen.get_path([0, 0])).to eql([[2, 2], [1, 1]])
    end
    it "handles negative cross diagonal movements" do
      queen = Queen.new([3, 3])
      expect(queen.get_path([0, 6])).to eql([[2, 4], [1, 5]])
    end
    it "doesn't path knights" do
      knight = Knight.new([3, 3])
      expect(knight.get_path([4, 5])).to eql([])
    end
  end

  describe "#move_to" do
    it "moves a piece to a position" do
      piece = King.new
      piece.position = [3, 3]
      piece.move_to([4, 4])
      expect(piece.position).to eql([4, 4])
    end
  end

end


RSpec.describe Pawn do

  describe "#promote" do
    it "gives a pawn the queen type" do
      pawn = Pawn.new
      pawn.promote
      expect(pawn.type).to eql("queen")
    end
    it "gives the pawn the queen's art" do
      pawn = Pawn.new
      pawn.promote
      expect(pawn.art).to eql("\u2655 ")
    end
    it "gives the pawn the queen's move options" do
      pawn = Pawn.new
      pawn.promote
      expect(pawn.instance_variable_get(:@moves).length).to eql(60)
    end
  end

end
