require_relative './coordinate'
module Gameboard
  class Cell
    attr_accessor :value
    attr_reader :coord
    def initialize(coord, value: false)
      raise TypeError unless coord.is_a?(Coordinate)
      @value = value
      @coord = coord
    end
  end
end