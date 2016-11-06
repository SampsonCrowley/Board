#empty?_spec
require 'rspec'
require 'gameboard/board'
require 'gameboard/cell'

describe Gameboard::Board do

  before do
    @gameboard = Gameboard::Board
  end

  include_context "board_spec"


  describe "#empty?" do
    it "returns true if the board is empty" do
      expect(valid_board.empty?).to be true
    end

    it "returns false if the board is not full" do
      almost_empty = [
                      [0,0,0,0],
                      [0,0,0,0],
                      [0,0,nil,0],
                      [0,0,0,0],
                     ]
      expect(subject.new(preset: [[0,nil]], cells: 0).empty?).not_to be true
      expect(subject.new(preset: almost_empty, cells: 0).empty?).not_to be true
    end
  end
end