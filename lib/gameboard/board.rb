require_relative './cell'
module Gameboard
  class Board
    attr_reader :cells, :height, :width, :board

    def initialize(height:false, width: false, cells: false, preset: false)
      raise ArgumentError unless ((height.is_a?(Integer) && width.is_a?(Integer)) || !!preset)
      @height = height
      @width = width
      @cells = cells || nil
      preset ? load_game(preset) : new_board
    end

    def new_board
      @board = []
      width.times do |x|
        height.times do |y|
          @board << Cell.new(Coordinate.new(x,y), value: @cells)
        end
      end
    end

    def load_game(saved_game)
      @board = []
      saved_game.reverse!
      @height = saved_game.length
      @width = saved_game[0].length
      saved_game.transpose.each_with_index do |row, x|
        row.each.each_with_index  do |cell, y|
          @board << Cell.new(Coordinate.new(x,y), value: cell)
        end
      end
    end

    def find_cell(coord)
      @board.find {|cell| 
        cell.coord.position == coord}
    end

  end
end
