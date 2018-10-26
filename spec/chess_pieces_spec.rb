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
  end











end
