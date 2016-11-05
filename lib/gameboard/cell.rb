require_relative './coordinate'
module Gameboard
  class Cell
    attr_accessor :value
    attr_reader :coordinates
    def initialize(coord, value: false)
      raise TypeError unless coord.is_a?(Coordinate)
      @value = value
    end
  end
end