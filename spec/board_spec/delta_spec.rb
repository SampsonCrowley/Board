#delta_spec.rb
require 'rspec'
require 'gameboard/board'
require 'gameboard/cell'

describe Gameboard::Board do

  before do
    @gameboard = Gameboard::Board
  end

  include_context "board_spec"


  describe "#delta" do
    it "takes a coordinate and a delta, and returns the value of the next available cell on that slope" do

      expect(preset.delta([0,1],[1,-1])).to eq(false)

    end

    it "raises an 'Off Grid' error if the calculated point would not be on the board" do

      expect{preset.delta([0,0],[-1,-1])}.to raise_error("Off Grid")

    end

    it "takes an optional boolean to return the coordinate of the found cell" do

      expect(preset.delta([0,1],[1,-1], true)).to eq([1,0])

    end
  end
end