#full_spec
require 'rspec'
require 'gameboard/board'
require 'gameboard/cell'
describe Gameboard::Board do

  before do
    @board = Gameboard::Board
  end

  include_context "board_spec"


  describe "#full" do
    it "checks if the board is full"
  end
  
end