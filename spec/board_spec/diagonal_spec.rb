#diagonal_spec.rb
require 'rspec'
require 'gameboard/board'
require 'gameboard/cell'

describe Gameboard::Board do

  before do
    @gameboard = Gameboard::Board
  end

  include_context "board_spec"


  describe "#diagonal" do

    it "returns board pieces for every possible diagonal. ordered largest to smallest, positive slope before negative, left to right." do
      # positive diagonals: [[0,0],[1,1]], [0,1], [1,0]
      # negative diagonals: [[0,1],[1,0]], [0,0], [1,1]
      # expect: p[0], n[0], p[1], n[1], p[2], n[2], p[3], n[4]
      #
      manual_diagonals = [[true, "X"], ["O", false],
                          ["O"], [true], [false], ["X"]]
      diags = preset.diagonal.each { |row| row.map! {|cell| cell.val } }
      expect(preset.to_val(:diagonal)).to eq(manual_diagonals)

    end

    it "is enumberable." do
      mapped_opposite_bool = [[false, false], [false, true],
                              [false], [false], [true], [false]]

      expect{preset.diagonal.each}.not_to raise_error
      mapped = preset.diagonal.map do |row|
        row.collect { |cell| cell.val == false  }
      end
      expect(mapped).to eq(mapped_opposite_bool)

    end

    it "using a destructive enumberable on #vertical will not modify underlying board data." do
      mapped_opposite_bool = [[false, false], [false, true],
                              [false], [false], [true], [false]]

      original = preset.to_val(:diagonal).dup
      mapped = preset.diagonal.map! do |row|
        row.collect { |cell| cell.val == false }
      end
      expect(mapped).to eq(mapped_opposite_bool)
      expect(preset.to_val(:diagonal)).to eq(original)

    end

  end

end