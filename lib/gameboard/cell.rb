require_relative './coordinate'
module Gameboard
  class Cell

    # Public: Returns the value of the Cell instance.
    attr_accessor :value

    # Public: Retuns the Coordinate of the Cell instance. Returns type
    #         Gameboard::Coordinate.
    attr_reader :coord

    # Public: Initialize the Cell.
    #
    # coord - A Coordinate class instance at postition X,Y.
    # value - The cell's value.
    #
    def initialize(coord: false, value: false)
      raise TypeError unless coord.is_a?(Coordinate)
      @value = value
      @coord = coord
    end
  end
end
