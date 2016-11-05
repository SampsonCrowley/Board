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
    it "randomizes the board with a given piece"
  end

end