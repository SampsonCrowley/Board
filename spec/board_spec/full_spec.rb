#full_spec
require 'rspec'
require 'gameboard/board'
require 'gameboard/cell'
describe Gameboard::Board do

  before do
    @gameboard = Gameboard::Board
  end

  include_context "board_spec"


  describe "#full?" do
    it "returns true if the board is full" do
      expect(preset.full?).to be true
    end

    it "returns false if the board is not full" do
      almost_full = [
                      [0,0,0,0],
                      [0,0,0,0],
                      [0,0,nil,0],
                      [0,0,0,0],

                    ]
      expect(subject.new(preset: [[0,nil]]).full?).not_to be true
      expect(subject.new(preset: almost_full).full?).not_to be true
    end

    it "accepts a range of coordinates to check if a smaller section of the board is full"
  end

end