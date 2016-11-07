#horizontal_spec.rb
require 'rspec'
require 'gameboard/board'
require 'gameboard/cell'

describe Gameboard::Board do

  before do
    @gameboard = Gameboard::Board
  end

  include_context "board_spec"


  describe "#horizontal" do

    it "returns board pieces row by row" do

      horiz = preset.horizontal.map { |row| row.map { |cell| cell.val } }

      expect(horiz).to eq([[true, false],["O", "X"]])

    end

    it "is enumberable." do

      expect{preset.horizontal.each}.not_to raise_error
      mapped = preset.horizontal.map do |row|
        row.collect { |e| e.val == false  }
      end
      expect(mapped).to eq([[false,true], [false, false]])

    end

    it "using a destructive enumberable on #horizontal will not modify underlying board data" do

      original = preset.horizontal.dup
      mapped = preset.horizontal.map! do |row|
        row.collect { |e| e.val == false  }
      end
      expect(mapped).to eq([[false,true], [false, false]])
      expect(preset.horizontal).to eq(original)

    end

  end

end