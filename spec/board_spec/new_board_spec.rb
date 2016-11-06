#new_board.rb
require 'rspec'
require 'gameboard/board'
require 'gameboard/cell'

describe Gameboard::Board do

  before do
    @gameboard = Gameboard::Board
  end

  include_context "board_spec"


  describe "#new_board" do

    it "creates a height x width grid" do
      expect(valid_board.instance_variable_get(:@board).length).to eq(10 * 10)
    end

    it "fills the grid with cells of default value" do
      default_cell_check = valid_board.instance_variable_get(:@board).all?{|cell| cell.is_a?(Gameboard::Cell)}
      expect(default_cell_check).to be true
      expect(valid_board.find_cell([0,0]).value).to be_nil
      expect(board_with_default.find_cell([0,0]).value).to eq("X")

    end

  end

end