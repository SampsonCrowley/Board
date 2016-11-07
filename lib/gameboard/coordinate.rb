module Gameboard
  class Coordinate
    # Public: Returns the X,Y coordinate of the instance as [X, Y].
    # Public: Returns the X coordinate of the instance.
    attr_reader :x
    # Public: Returns the Y coordinate of the instance.
    attr_reader :y

    # Public: Initialize the Cell.
    #
    # x - The X coordinat
    # y - The Y coordinate in an X,Y grid.
    #
    def initialize(x,y)
      invalid_type = "Coordinates must be integers!"
      raise invalid_type unless (x.is_a?(Integer) && y.is_a?(Integer))
      @x = x
      @y = y
    end

    # Public: return neigboring coordinates relative to :position.
    #
    # Examples
    #
    #   Coordinate.new(1,1).neighbors
    #     #=> [
    #           [0, 2], [1, 2],
    #           [2, 2], [0, 1],
    #           [2, 1], [0, 0],
    #           [0, 1], [0, 2]
    #         ]
    def neighbors
      relative_neighbors.map { |point| delta(point) }
    end

    def position
      [x, y]
    end
    private

      # Internal: Add an array with :position.
      #
      # Examples
      #
      #   Coordinate.new(1,1).delta([2,2])
      #     #=> [3, 3]
      #
      def delta(point)
        point.zip(position).map {|combined| combined.reduce(:+) }
      end

      # Internal: Array of possible neigbors.
      #
      def relative_neighbors
        [
          [-1, 1], [0, 1], [1, 1],
          [-1, 0], [1, 0],
          [-1, -1], [-1, 0], [-1, 1]
        ]
      end
  end
end
