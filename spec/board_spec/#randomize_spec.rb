#randomize_spec.rb
require 'rspec'
require 'gameboard/board'
require 'gameboard/cell'
describe Gameboard::Board do

  before do
    @board = Gameboard::Board
  end

  include_context "board_spec"


  describe "#randomize" do
    it "should randomize the board with the default piece"
  end
  
end