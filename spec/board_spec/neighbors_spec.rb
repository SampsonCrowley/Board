#neighbors_spec.rb

require 'rspec'
require 'gameboard/board'
require 'gameboard/cell'

describe Gameboard::Board do

  before do
    @board = Gameboard::Board
  end

  include_context "board_spec"

  describe "#neighbors" do

    it "returns an array of all existing neigbors values" do
      expect(preset.neighbors([0,0])).to eq (["O", "X", false])
    end

    it "accepts a boolean to return valid coordinate points" do
      expect(preset.neighbors([0,0],true)).to eq ([[0,1], [1,1], [1,0]])
    end

  end

end