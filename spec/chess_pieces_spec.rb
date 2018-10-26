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

  describe "#move" do
    it "moves a piece from start position to finish position" do
      piece = King.new
      piece.position = [3, 3]
      piece.move([3, 3], [4, 4])
      expect(piece.position).to eql([4, 4])
    end
    it "does not move a piece if the move would be illegal" do
      piece = King.new
      piece.position = [3, 3]
      piece.move([3, 3], [4, 5])
      expect(piece.position).to eql([3, 3])
    end
    it "correctly moves a King" do
      piece = King.new
      piece.position = [3, 3]
      piece.move([3, 3], [4, 4])
      expect(piece.position).to eql([4, 4])
    end
    it "correctly moves a Queen" do
      piece = Queen.new
      piece.position = [2, 3]
      piece.move([2, 3], [4, 1])
      expect(piece.position).to eql([4, 1])
    end
    it "correctly moves a Rook" do
      piece = Rook.new
      piece.position = [3, 3]
      piece.move([3, 3], [3, 6])
      expect(piece.position).to eql([3, 6])
    end
    it "correctly moves a Bishop" do
      piece = Bishop.new
      piece.position = [3, 3]
      piece.move([3, 3], [6, 6])
      expect(piece.position).to eql([6, 6])
    end
    it "correctly moves a Knight" do
      piece = Knight.new
      piece.position = [3, 3]
      piece.move([3, 3], [4, 5])
      expect(piece.position).to eql([4, 5])
    end
    it "correctly moves a white Pawn" do
      piece = Pawn.new
      piece.position = [3, 3]
      piece.move([3, 3], [3, 4])
      expect(piece.position).to eql([3, 4])
    end
    it "correctly moves a black Pawn" do
      piece = Pawn.new([3, 3], "black")
      piece.move([3, 3], [3, 2])
      expect(piece.position).to eql([3, 2])
    end
  end




end
