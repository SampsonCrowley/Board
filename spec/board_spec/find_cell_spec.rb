#return_cell_spec.rb
require 'rspec'
require 'gameboard/board'
require 'gameboard/cell'

describe Gameboard::Board do

  before do
    @gameboard = Gameboard::Board
  end

  include_context "board_spec"


  describe "#find_cell" do
    before do

    end
    it "returns the cell at coordinate [x,y]" do
      expect(preset.find_cell([0,0]).val).to eq(true)
      expect(preset.find_cell([0,0]).coord.position).to eq([0, 0])
      expect(preset.find_cell([1,0]).val).to be false
      expect(preset.find_cell([0,1]).val).to eq("O")
      expect(preset.find_cell([1,1]).val).to eq("X")
    end
  end

end