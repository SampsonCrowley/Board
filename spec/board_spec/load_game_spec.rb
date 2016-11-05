#load_game_spec.rb
require 'rspec'
require 'gameboard/board'
require 'gameboard/cell'

describe Gameboard::Board do

  before do
    @board = Gameboard::Board
  end

  include_context "board_spec"


  describe "#load_game" do
    before do

    end
    it "sets a load gameboard when passed a 2D array in the form of
    [
      [top row],
      [middle row],
      [bottom row],
    ]
    " do
        valid_board.load_game(full_board)
        all_pieces = valid_board.board.all?{|cell| cell.value == "X"}
        
        expect(all_pieces).to be true
        valid_board.load_game(mixed_board)
        board = valid_board.board
        piece0_0 = board.find {|cell| cell.coord.position == [0,0]}
        piece0_1 = board.find {|cell| cell.coord.position == [0,1]}
        piece1_0 = board.find {|cell| cell.coord.position == [1,0]}
        piece1_1 = board.find {|cell| cell.coord.position == [1,1]}


        expect(piece0_0.value).to be true
        expect(piece0_1.value).to eq("O")
        expect(piece1_0.value).to be false
        expect(piece1_1.value).to eq("X")

    end
  end
  
end