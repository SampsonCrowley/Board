#vertical_spec.rb
require 'rspec'
require 'gameboard/board'
require 'gameboard/cell'

describe Gameboard::Board do

  before do
    @gameboard = Gameboard::Board
  end

  include_context "board_spec"


  describe "#vertical" do

    it "returns board pieces column by column" do

      expect(preset.to_val(:vertical)).to eq([[true, "O"],[false, "X"]])

    end

    it "is enumberable." do

      expect{preset.vertical.each}.not_to raise_error
      mapped = preset.vertical.map do |column|
        column.collect { |cell| cell.val == false  }
      end
      expect(mapped).to eq([[false, false], [true, false]])

    end

    it "using a destructive enumberable on #vertical will not modify underlying board data" do

      original = preset.vertical.dup
      mapped = preset.vertical.map! do |column|
        column.collect { |cell| cell.val == false  }
      end
      expect(mapped).to eq([[false, false], [true, false]])
      expect(preset.vertical).to eq(original)

    end

  end

end