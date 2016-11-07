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
      expect{subject.new}.to raise_error(TypeError)
    end

    it "does not require a default value" do
      expect{subject.new(coord: coord)}.not_to raise_error
    end

    it "coordinates are from the Coordinate class" do
      expect{subject.new(coord: "", val: "X")}.to raise_error(TypeError)
    end

    it "accepts a default value" do
      expect(subject.new(coord: coord, val: "X").val).to eq("X")
    end

  end

end