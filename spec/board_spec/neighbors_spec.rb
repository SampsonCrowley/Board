#neighbors_spec.rb

require 'rspec'
require 'gameboard/board'
require 'gameboard/cell'
require 'gameboard/coordinate'

describe Gameboard::Board do

  before do
    @gameboard = Gameboard::Board
  end

  include_context "board_spec"

  describe "#neighbors" do

    it "returns an array of all existing neigbors values" do
      expect(preset.to_val(:neighbors,[0,0])).to eq (["O", "X", false])
    end

  end

end