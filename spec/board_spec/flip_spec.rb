require 'rspec'
require 'gameboard/board'
require 'gameboard/cell'

describe Gameboard::Board do

  before do
    @gameboard = Gameboard::Board
  end

  include_context "board_spec"


  describe "#flip" do
    it "resets the board in a fit of rage" do
      preset.flip
      result = true
      preset.horizontal.each do |row|
        result = row.all? {|cell| cell.nil? }
        break unless result
      end
      expect(result).to be true
    end

    it "raises 'The Board is Nailed to the Table' if the board is nailed down" do
      preset.nail_down
      expect{ preset.flip }.to raise_error("The Board is Nailed to the Table")
    end
  end
end