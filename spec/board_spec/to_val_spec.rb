#to_val_spec.rb
require 'rspec'
require 'gameboard/board'
require 'gameboard/cell'

describe Gameboard::Board do

  before do
    @gameboard = Gameboard::Board
  end

  include_context "board_spec"


  describe "#to_val" do
    it "returns values instead of cells for a given method" do

      expect(preset.to_val(:horizontal)).to eq([[true, false],["O", "X"]])

    end

    it "accepts and optional argument to pass to the called method" do

      expect{preset.to_val(:neighbors,[0,0])}.not_to raise_error
      expect(preset.to_val(:neighbors,[0,0])).to eq (["O", "X", false])

    end

    it "only calls public methods" do
      expect{preset.to_val(:get_diagonal,[0, 0])}.to raise_error(NoMethodError)
    end

  end
end