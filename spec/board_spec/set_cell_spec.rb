#set_piece_spec.rb
require 'rspec'
require 'gameboard/board'
require 'gameboard/cell'

describe Gameboard::Board do

  before do
    @gameboard = Gameboard::Board
  end

  include_context "board_spec"

  describe "#set_cell" do

    it "sets a piece at a given coordinate" do
      valid_board.set_cell([0,0], 7)
      expect(valid_board.find_cell([0,0]).val).to eq(7)
    end

    it "returns false if cell doesn't exist" do
      expect(valid_board.set_cell([50,50], 7)).to be false
    end
  end
end