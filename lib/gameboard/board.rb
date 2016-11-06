require_relative './cell'

module Gameboard
  class Board
    attr_reader :height, :width, :board
    include Enumerable

    def initialize(height:false, width: false, cells: false, preset: false)
      raise ArgumentError unless ((height.is_a?(Integer) && width.is_a?(Integer)) || !!preset)
      @height = height
      @width = width
      @cells = cells || nil
      preset ? load_game(preset) : new_board
    end

    def each(&block)
      return enum_for(__method__) if block.nil?
      board.each(&block)
      board
    end

    def each_value(&block)
      return enum_for(__method__) if block.nil?
      each{|cell| yield(cell.value)}
    end

    def each_coordinate(&block)
      return enum_for(__method__) if block.nil?
      each { |cell| yield(cell.coord.position) }
    end

    def delta(point, slope, coord = false)
      delta =  point.zip(slope).map {|point| point.reduce(:+) }
      piece = board.find { |cell| cell.coord.position == delta }
      raise "Off Grid" unless !!piece
      coord ? piece.coord.position : piece.value
    end

    def diagonal(coords = false)
      diagonals = []

      height.times do |i|
        diagonals << get_diagonal([0, i], coords)
        diagonals << get_diagonal([0, height - 1 - i], coords, false)
      end
      (1...width).each do
        |i| diagonals << get_diagonal([i, 0], coords)
        diagonals << get_diagonal([i, height - 1], coords, false)
      end

      diagonals
    end

    def find_cell(coord)
      board.find {|cell| cell.coord.position == coord}
    end

    def full?
      board.none? { |cell| cell.value == cells  }
    end

    def horizontal(coords = false)
      rows = []
      height.times do |y|
        rows << board.select { |cell| cell.coord.y == y }.map do |cell|
          coords ? cell.coord.position : cell.value
        end
      end
      rows
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

    def neighbors(coord, points = false)
      temp = Coordinate.new(coord[0], coord[1])
      valid_neighbors(temp).map do |cell|
        points ? cell.coord.position : cell.value
      end
    end

    def new_board
      @board = []
      width.times do |x|
        height.times do |y|
          @board << Cell.new(Coordinate.new(x,y), value: cells)
        end
      end
    end

    def vertical(coords = false)
      columns = []
      width.times do |x|
        columns << board.select { |cell| cell.coord.x == x }.map do |cell|
          coords ? cell.coord.position : cell.value
        end
      end
      columns
    end

    private
      attr_reader :cells

      def get_diagonal(start, coords, slope = true)
        oper = (slope == true ? :+ : :-)
        diagonal = (0...height).map do |i|
          position = [start[0] + i, start[1].send(oper, i)]
          if ((0...width).include?(start[0] + i) && (0...height).include?(start[1].send(oper, i)))
            board.find {|cell| cell.coord.position == position}
          end
        end
        diagonal.compact.map{|cell| coords ? cell.coord.position : cell.value }
      end

      def valid_neighbors(coord)
        coord.neighbors.collect { |point| find_cell(point) }.compact
      end
  end
end
