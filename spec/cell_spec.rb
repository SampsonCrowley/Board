require 'rspec'
require 'gameboard/cell'
require 'gameboard/coordinate'

describe Gameboard::Cell do
  before do
    @cell = Gameboard::Cell
  end

  let(:coord) {Gameboard::Coordinate.new(0,0)}
  subject { @cell }

  describe "#new" do

    it "requires coordinates" do
      expect{subject.new}.to raise_error(ArgumentError)
    end

    it "coordinates are from the Coordinate class" do
      expect{subject.new("", value: "X")}.to raise_error(TypeError)
    end

    it "accepts a default value" do
      expect(subject.new(coord, value: "X").value).to eq("X")
    end

  end

end