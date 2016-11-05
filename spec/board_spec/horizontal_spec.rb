#horizontal_spec.rb
require 'rspec'
require 'gameboard/board'
require 'gameboard/cell'

describe Gameboard::Board do

  before do
    @board = Gameboard::Board
  end

  include_context "board_spec"


  describe "#horizontal" do

    it "returns board pieces row by row" do

      expect(preset.horizontal).to eq([[true, false],["O", "X"]])

    end

    it "is enumberable." do

      expect{preset.horizontal.each}.not_to raise_error
      mapped = preset.horizontal.map do |row|
        row.collect { |e| e == false  }
      end
      expect(mapped).to eq([[false,true], [false, false]])

    end

    it "using a destructive enumberable on #horizontal will not modify underlying board data" do

      original = preset.horizontal.dup
      mapped = preset.horizontal.map! do |row|
        row.collect { |e| e == false  }
      end
      expect(mapped).to eq([[false,true], [false, false]])
      expect(preset.horizontal).to eq(original)

    end

    it "accepts a boolean to return an array of coordinates instead of values" do

      expect{preset.horizontal(true)}.not_to raise_error
      expect(preset.horizontal(true)).to eq([[[0,0], [1,0]],[[0,1],[1,1]]])

    end
  end

end