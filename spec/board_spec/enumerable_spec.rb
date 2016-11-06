#enumerable_spec.rb
require 'rspec'
require 'gameboard/board'
require 'gameboard/cell'

describe Gameboard::Board do

  before do
    @gameboard = Gameboard::Board
  end

  let(:temp) { temp = [] }

  include_context "board_spec"


  describe "#each" do

    it "enumerates through the board (from the bottom row up) and returns each cell" do

      preset.each do |cell|
        temp << cell
      end
      expect{preset.each}.not_to raise_error
      expect(temp.all?{|cell| cell.is_a?(Gameboard::Cell)}).to be true

    end
  end

  describe "#each_value" do
    it "enumerates through the board (from the bottom row up) and returns each cells value" do

      preset.each_value do |cell|
        temp << cell
      end
      expect{preset.each_value}.not_to raise_error
      expect(temp.include?("X")).to be true

    end
  end

  describe "#each_coordinate" do
    it "enumerates through the board (from the bottom row up) and returns each cells coordinates" do

      preset.each_coordinate do |cell|
        temp << cell
      end
      p temp
      expect{preset.each_coordinate}.not_to raise_error
      expect(temp.include?([0,0])).to be true

    end
  end

end