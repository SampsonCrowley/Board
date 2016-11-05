module Gameboard
  class Coordinate
    attr_reader :position, :x, :y
    def initialize(x,y)
      invalid_type = "Coordinates must be integers!"
      raise invalid_type unless (x.is_a?(Integer) && y.is_a?(Integer))
      @position = [x,y]
      @x = x
      @y = y
    end
  end
end