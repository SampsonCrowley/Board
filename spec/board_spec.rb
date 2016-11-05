require 'rspec'
require 'gameboard/board'
require 'gameboard/cell'

describe Gameboard::Board do

  before do
    @board = Gameboard::Board
  end

  subject { @board }
  let(:valid_board) {@board.new( height: 10, width: 10 )}
  let(:board_with_default) {@board.new( height: 10, width: 10, cells: "X" )}

  describe "#new" do

    it "accepts ( :height ) and ( :width ) as a parameter" do
      expect { valid_board }.to_not raise_error
      expect { subject.new( width: 10, height: 10 ) }.to_not raise_error
      expect( valid_board.height ).to eq(10)
      expect( valid_board.width ).to eq(10)
    end

    it "accepts ( :cells ) as an argument" do
      expect { subject.new( height: 10, width: 10, cells: " " ) }.to_not raise_error
      expect { subject.new( cells: " ", height: 10, width: 10 ) }.to_not raise_error
      expect(subject.new( cells: " ", height: 10, width: 10).cells).to eq(" ")
    end

    it "creates empty cells if no default value is given" do
      expect(valid_board.cells).to be_nil
    end

    it "accepts raise an error if height or width is not specified" do
      expect { subject.new }.to raise_error(ArgumentError)
      expect { subject.new(height: 10) }.to raise_error(ArgumentError)
      expect { subject.new(width: 10) }.to raise_error(ArgumentError)
    end

    it "raises an error if height or width is not an integer" do
      expect { subject.new(height: "string", width: 10) }.to raise_error(ArgumentError)
      expect { subject.new(height: 10, width: "string") }.to raise_error(ArgumentError)
      expect { subject.new(height: "string", width: "string") }.to raise_error(ArgumentError)
    end

    it "sets up a new board" do
      expect_any_instance_of(subject).to receive(:new_board)
      valid_board
    end

  end

  describe "#new_board" do

    it "creates a height x width grid" do
      expect(valid_board.board.length).to eq(10 * 10)
    end

    it "fills the grid with cells of default value" do
      default_cell_check = valid_board.board.all?{|cell| cell.is_a?(Gameboard::Cell)}
      expect(default_cell_check).to be true
      expect(valid_board.board[0].value).to be_nil
      expect(board_with_default.board[0].value).to eq("X")

    end

  end

  describe "#randomize" do
    it "should randomize the board with the default piece"
  end
  
end