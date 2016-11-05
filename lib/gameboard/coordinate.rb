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

    def neighbors
      relative_neighbors.map { |point| delta(point) }
    end
    private
      def delta(point)
        point.zip(position).map {|combined| combined.reduce(:+) }
      end

      def relative_neighbors
        [
          [-1, 1], [0, 1], [1, 1],
          [-1, 0], [1, 0],
          [-1, -1], [-1, 0], [-1, 1]
        ]
      end
  end
end
