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
    it "returns the value of cell at coordinate [x,y]" do
      expect(preset.find_cell([0,0]).value).to be true
      expect(preset.find_cell([1,0]).value).to be false
      expect(preset.find_cell([0,1]).value).to eq("O")
      expect(preset.find_cell([1,1]).value).to eq("X")
    end
  end

end