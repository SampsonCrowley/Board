#randomize_spec.rb
require 'rspec'
require 'gameboard/board'
require 'gameboard/cell'
describe Gameboard::Board do

  before do
    @gameboard = Gameboard::Board
  end

  include_context "board_spec"


  describe "#randomize" do
    it "randomizes the board with a given piece" do
      valid_board.randomize("Y")
      result = false
      valid_board.to_val(:horizontal).each do |row|
        result = row.any?{ |cell| cell == "Y" }
        break if !!result
      end
      expect(result).to be true
    end
  end

end