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
    it "takes a coordinate and a delta, and returns the next available cell on that slope" do

      expect(preset.delta([0,1],[1,-1]).val).to eq(false)

    end

    it "returns nil if the calculated point would not be on the board" do

      expect(preset.delta([0,0],[-1,-1])).to be_nil

    end

  end
end