require 'rspec'
require 'gameboard/board'
require 'gameboard/cell'

describe Gameboard::Board do

  before do
    @gameboard = Gameboard::Board
  end

  include_context "board_spec"


  describe "#nail_down" do
    it "nails the board down so it can't be flipped" do 
      valid_board.nail_down
      expect(valid_board.nailed_down?).to be true
    end
  end
end