require 'rspec'
require 'gameboard/cell'
require 'gameboard/coordinate'

describe Gameboard::Coordinate do

  let(:coord) { Gameboard::Coordinate.new(2,3) }

  subject { coord }

  describe "#new" do

    it "requires a set of x, y coordinates" do

      expect{Gameboard::Coordinate.new}.to raise_error(ArgumentError)
      expect{Gameboard::Coordinate.new(0,0)}.not_to raise_error(ArgumentError)

    end

    it "requires both x and y to be integers" do

      expect{Gameboard::Coordinate.new("x", 9)}.to raise_error("Coordinates must be integers!")

    end

  end

  describe "#postition" do
    it "returns an array of x, y coordinates" do

      expect(subject.position).to eq([2,3])

    end
  end
  
  it "returns the x coordinate" do

    expect(subject.x).to eq(2)

  end

  it "returns the y coordinate" do

    expect(subject.y).to eq(3)

  end

end