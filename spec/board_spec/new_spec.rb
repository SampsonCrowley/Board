#new_spec.rb
require 'rspec'
require 'gameboard/board'
require 'gameboard/cell'

describe Gameboard::Board do

  before do
    @gameboard = Gameboard::Board
  end

  include_context "board_spec"

  describe "#new" do

    it "requires ( :height ) and ( :width ) as arguments" do
      expect { valid_board }.to_not raise_error
      expect { subject.new( width: 10, height: 10 ) }.to_not raise_error
      expect( valid_board.height ).to eq(10)
      expect( valid_board.width ).to eq(10)
    end

    it "raises ArgumentError if height or width is not specified" do
      expect { subject.new }.to raise_error(ArgumentError)
      expect { subject.new(height: 10) }.to raise_error(ArgumentError)
      expect { subject.new(width: 10) }.to raise_error(ArgumentError)
    end

    it "raises an error if height or width is not an integer" do
      expect { subject.new(height: "string", width: 10) }.to raise_error(ArgumentError)
      expect { subject.new(height: 10, width: "string") }.to raise_error(ArgumentError)
      expect { subject.new(height: "string", width: "string") }.to raise_error(ArgumentError)
    end

    it "accepts ( :cells ) as an argument" do
      expect { subject.new( height: 10, width: 10, cells: " " ) }.to_not raise_error
      expect { subject.new( cells: " ", height: 10, width: 10 ) }.to_not raise_error
      expect(subject.new( cells: " ", height: 10, width: 10).find_cell([0,0]).value).to eq(" ")
    end

    it "creates empty cells if ( :cells ) is not passed as an argument" do
      expect(valid_board.find_cell([0,0]).value).to be_nil
    end

    it "sets up a new board" do
      expect_any_instance_of(subject).to receive(:new_board)
      valid_board
    end

    it "allows a preset 2D array to be passed as a default_board" do
      board = subject.new(preset: mixed_board, height: 10, width: 10)
      piece0_0 = board.find {|cell| cell.coord.position == [0,0]}
      piece0_1 = board.find {|cell| cell.coord.position == [0,1]}
      piece1_0 = board.find {|cell| cell.coord.position == [1,0]}
      piece1_1 = board.find {|cell| cell.coord.position == [1,1]}


      expect(piece0_0.value).to be true
      expect(piece0_1.value).to eq("O")
      expect(piece1_0.value).to be false
      expect(piece1_1.value).to eq("X")
    end

    it "does not require a height and width if passed a preset board" do
      expect{subject.new(preset: mixed_board)}.not_to raise_error
    end

  end

end