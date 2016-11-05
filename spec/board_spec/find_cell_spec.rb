#return_cell_spec.rb
require 'rspec'
require 'gameboard/board'
require 'gameboard/cell'

describe Gameboard::Board do

  before do
    @board = Gameboard::Board
  end

  include_context "board_spec"


  describe "#find_cell" do
    before do

    end
    it "returns the value of cell at coordinate [x,y]" do
      valid_board.load_game(mixed_board)
      expect(valid_board.find_cell([0,0]).value).to be true
      expect(valid_board.find_cell([1,0]).value).to be false
      expect(valid_board.find_cell([0,1]).value).to eq("O")
      expect(valid_board.find_cell([1,1]).value).to eq("X")
    end
  end

end