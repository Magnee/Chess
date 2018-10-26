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
  end











end
