require_relative './cell'
module Gameboard
  class Board
    attr_reader :cells, :height, :width, :board

    def initialize(height:false, width: false, cells: false)
      raise ArgumentError unless (height.is_a?(Integer) && width.is_a?(Integer))
      @height = height
      @width = width
      @cells = cells || nil
      new_board
    end

    def new_board
      @board = []
      i = 0
      width.times do |x|
        height.times do |y|
          @board << Cell.new(Coordinate.new(x,y), value: @cells)
        end
      end
    end

    

  end
end
