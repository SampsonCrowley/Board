require_relative './cell'

module Gameboard
  # The Main Board Model

  class Board
    # Public: Returns the height of the gameboard.
    attr_reader :height

    # Public: Returns the width of the gameboard.
    attr_reader :width

    include Enumerable

    # Public: Initialize a gameboard.
    #
    # height - The number of horizontal rows on the gameboard. Not passing a
    #          height will raise an ArgumentError unless a preset board is
    #          passed
    # width  - The number of columns on the gameboard. Not passing a
    #          width will raise an ArgumentError unless a preset board is
    #          passed
    # cells  - An optional value, preferably a String in most cases, that
    #          changes the default cell value.
    # preset - An optional 2D Array to load a preset gameboard. Saved games
    #          should be created in rows from the top down.
    #
    # Examples
    #
    #   board = Board.new(cells: "O", width: 10, height: 8)
    #   # =>     -----------------------------------------
    #          0 | O | O | O | O | O | O | O | O | O | O |
    #            -----------------------------------------
    #          1 | O | O | O | O | O | O | O | O | O | O |
    #            -----------------------------------------
    #          2 | O | O | O | O | O | O | O | O | O | O |
    #            -----------------------------------------
    #          3 | O | O | O | O | O | O | O | O | O | O |
    #            -----------------------------------------
    #          4 | O | O | O | O | O | O | O | O | O | O |
    #            -----------------------------------------
    #          5 | O | O | O | O | O | O | O | O | O | O |
    #            -----------------------------------------
    #          6 | O | O | O | O | O | O | O | O | O | O |
    #            -----------------------------------------
    #          7 | O | O | O | O | O | O | O | O | O | O |
    #            -----------------------------------------
    #            - 0 - 1 - 2 - 3 - 4 - 5 - 6 - 7 - 8 - 9 -
    #
    #
    #   example_arr = [
    #                  ["1", "2", "3"], #=> coordinates [[0,2], [1,2], [2,2]]
    #                  ["A", "B", "C"], #=> coordinates [[0,1], [1,1], [2,1]]
    #                  ["X", "Y", "Z"]  #=> coordinates [[0,0], [1,0], [2,0]]
    #                 ]
    #
    #   board = Board.new(preset: example_array)
    #           #=>     -------------
    #                 0 | 1 | 2 | 3 |
    #                   -------------
    #                 1 | A | B | C |
    #                   -------------
    #                 2 | X | Y | Z |
    #                   -------------
    #                   - 0 - 1 - 2 -
    #
    #
    def initialize(height:false, width: false, cells: false, preset: false)
      raise ArgumentError unless ((height.is_a?(Integer) && width.is_a?(Integer)) || !!preset)
      @height = height
      @width = width
      @cells = cells || nil
      preset ? load_game(preset) : new_board
    end

    # Public: An enumerator that passes the individual cells.
    #
    # block - Individual cells have a :coord and a :value method where :coord
    #         is a member of the Coordinate class
    #
    # Example
    #
    #   board.each { |cell| p cell }
    #     #=> #<Gameboard::Cell:0x005637e5004790
    #            @value = "O",
    #            @coord = #<Gameboard::Coordinate:0x005637e5004a88
    #                        @position = [0, 0], @x = 0, @y = 0>>
    #
    #     #=> #<Gameboard::Cell...
    #
    def each(&block)
      return enum_for(__method__) if block.nil?
      board.each(&block)
      board
    end

    # Public: An enumerator that yields each cells value.
    # Example
    #
    #   board.each_value { |cell| p cell }
    #     #=> "O"
    #     #=> "X"
    #     #=> "X"...
    #
    def each_value(&block)
      return enum_for(__method__) if block.nil?
      each{|cell| yield(cell.value)}
    end

    # Public: An enumerator that yields each cells coordinates.
    # Example
    #
    #   board.each { |cell| p cell }
    #     #=> [0, 0]
    #     #=> [1, 0]
    #     #=> [2, 0]
    #     #=> [0, 1]
    #     #=> [1, 1]...
    #
    def each_coordinate(&block)
      return enum_for(__method__) if block.nil?
      each { |cell| yield(cell.coord.position) }
    end

    # Public: Return the value of the next available point given a coordinate
    #         and a slope.
    #
    # point  - The starting coordinate pair.
    # slope  - An [x, y] slope (e.g. [1,1] means over one row, up one column).
    #          It must be an integer.
    # coords - An optional boolean to specify returning a coordinate pair
    #          instead of a value.
    #
    # Example
    #   given_board =   -------------
    #                 0 | 1 | 2 | 3 |
    #                   -------------
    #                 1 | A | B | C |
    #                   -------------
    #                 2 | X | Y | Z |
    #                   -------------
    #                   - 0 - 1 - 2 -
    #
    #   delta([1,1], [-1, 1])
    #     #=> 1 ([0,2] if coord argument given)
    #
    #   delta([0,0], [2, 1])
    #     #=> C ([2,1] if coord argument given)
    #
    def delta(point, slope, coords = false)
      delta =  point.zip(slope).map {|point| point.reduce(:+) }
      piece = board.find { |cell| cell.coord.position == delta }
      raise "Off Grid" unless !!piece
      coords ? piece.coord.position : piece.value
    end

    # Public: Return every diagonal on the gameboard. It does not require a
    #         square board to function.
    #
    # coords: An optional boolean to specify returning an Array of coordinates
    #         instead of values.
    #
    # Example
    #      -------------
    #    0 | 1 | 2 | 3 |
    #      -------------
    #    1 | A | B | C |
    #      -------------
    #    2 | X | Y | Z |
    #      -------------
    #      - 0 - 1 - 2 -
    #
    #
    #   diagonal
    #     #=> [
    #          ["X", "B", 3], [1, "B", "Z"],
    #          ["A", 2], ["A", "Y"], [1], ["X"],
    #          ["Y", "C"], [2, "C"], ["Z"], [3]
    #         ]
    #
    #   diagonal(true)
    #     #=> [
    #          [[0, 0], [1, 1], [2, 2]],
    #          [[0, 2], [1, 1], [2, 0]],
    #          [[0, 1], [1, 2]],
    #          [[0, 1], [1, 0]],
    #          [[0, 2]],
    #          [[0, 0]],
    #          [[1, 0], [2, 1]],
    #          [[1, 2], [2, 1]],
    #          [[2, 0]],
    #          [[2, 2]]
    #         ]
    #
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

    # Public: Find a cell at given coordinate.
    #
    # coord - An X,Y coordinate passed as an Array.
    #
    # Example
    #      -------------
    #    0 | 1 | 2 | 3 |
    #      -------------
    #    1 | A | B | C |
    #      -------------
    #    2 | X | Y | Z |
    #      -------------
    #      - 0 - 1 - 2 -
    #
    #
    #   find_cell([1,0])
    #     #=> Y
    #
    #   find_cell([2,2])
    #     #=> 3
    #
    # find_cell([0,1])
    #     #=> A
    #
    def find_cell(coord)
      board.find {|cell| cell.coord.position == coord}
    end

    # Public: Check if the gameboard is full relative to the default cell.
    #
    #
    #
    # Example
    #
    #    Board.new(height: 3, width: 3)
    #      -------------
    #    0 | 1 | 2 | 3 |
    #      -------------
    #    1 | A | B | C |
    #      -------------
    #    2 | X | Y | Z |
    #      -------------
    #      - 0 - 1 - 2 -
    #
    #   full?
    #     #=> true
    #
    #   Board.new(height: 3, width: 3, cells: "Y")
    #
    #   full?
    #     #=> false (because our default piece is now "Y")
    #
    def full?
      board.none? { |cell| cell.value == cells  }
    end

    # Public: Return every row on the gameboard.
    #
    # coords: An optional boolean to specify returning an Array of coordinates
    #         instead of values.
    #
    # Example
    #      -------------
    #    0 | 1 | 2 | 3 |
    #      -------------
    #    1 | A | B | C |
    #      -------------
    #    2 | X | Y | Z |
    #      -------------
    #      - 0 - 1 - 2 -
    #
    #
    #   horizontal
    #     #=> [
    #          ["X", "Y", "Z"],
    #          ["A", "B", "C"],
    #          [1, 2, 3]
    #         ]
    #
    #   horizontal(true)
    #     #=> [
    #          [[0, 0], [1, 0], [2, 0]],
    #          [[0, 1], [1, 1], [2, 1]],
    #          [[0, 2], [1, 2], [2, 2]]]
    #         ]
    #
    def horizontal(coords = false)
      rows = []
      height.times do |y|
        rows << board.select { |cell| cell.coord.y == y }.map do |cell|
          coords ? cell.coord.position : cell.value
        end
      end
      rows
    end

    # Public: Return all valid neighbors of a given coordinate.
    #
    # point  - The X,Y coordinate neighbors should be based off of.
    # coords - An optional boolean to return an array of coordinate pairs
    #
    #
    # Examples
    #                   -------------
    #                 0 | 1 | 2 | 3 |
    #                   -------------
    #                 1 | A | B | C |
    #                   -------------
    #                 2 | X | Y | Z |
    #                   -------------
    #                   - 0 - 1 - 2 -
    #
    #   neighbors([1,1])
    #           #=> [1, 2, 3, "A", "C", "X", "A", 1]
    #
    #   neighbors([1,1] true)
    #           #=> [
    #                [0, 2], [1, 2],
    #                [2, 2], [0, 1],
    #                [2, 1], [0, 0],
    #                [0, 1], [0, 2]
    #               ]
    #
    #
    def neighbors(point, coords = false)
      temp = Coordinate.new(point[0], point[1])
      valid_neighbors(temp).map do |cell|
        coords ? cell.coord.position : cell.value
      end
    end

    # Public: Set a cells value at a given coordinate
    # 
    # coord - A coordinate pair in the form X, Y
    def set_cell(coord, value)
      cell = find_cell(coord)
      raise "Cell Not Found" unless !!cell
      cell.value = value
    end

    # Public: Return every column on the gameboard.
    #
    # coords: An optional boolean to specify returning an Array of coordinates
    #         instead of values.
    #
    # Example
    #      -------------
    #    0 | 1 | 2 | 3 |
    #      -------------
    #    1 | A | B | C |
    #      -------------
    #    2 | X | Y | Z |
    #      -------------
    #      - 0 - 1 - 2 -
    #
    #
    #   vertical
    #     #=> [
    #          ["X", "A", 1],
    #          ["Y", "B", 2],
    #          ["Z", "C", 3]
    #         ]
    #
    #   vertical(true)
    #     #=> [
    #          [[0, 0], [0, 1], [0, 2]],
    #          [[1, 0], [1, 1], [1, 2]],
    #          [[2, 0], [2, 1], [2, 2]]]
    #         ]
    #
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
      # Internal: Returns the gameboard array.
      attr_reader :board
      # Internal: Returns the default gameboard cell value
      attr_reader :cells

      # Internal: return a diagonal array given a starting point and a
      #           slope.
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

      # Internal: Set the current gameboard.
      #
      # saved_game - An 2D Array. Saved games should be created in rows from
      #              the top down.
      #
      #
      # Examples
      #
      #   board = Board.new(cells: "O", width: 10, height: 8)
      #   # =>     -----------------------------------------
      #          0 | O | O | O | O | O | O | O | O | O | O |
      #            -----------------------------------------
      #          1 | O | O | O | O | O | O | O | O | O | O |
      #            -----------------------------------------
      #          2 | O | O | O | O | O | O | O | O | O | O |
      #            -----------------------------------------
      #          3 | O | O | O | O | O | O | O | O | O | O |
      #            -----------------------------------------
      #          4 | O | O | O | O | O | O | O | O | O | O |
      #            -----------------------------------------
      #          5 | O | O | O | O | O | O | O | O | O | O |
      #            -----------------------------------------
      #          6 | O | O | O | O | O | O | O | O | O | O |
      #            -----------------------------------------
      #          7 | O | O | O | O | O | O | O | O | O | O |
      #            -----------------------------------------
      #            - 0 - 1 - 2 - 3 - 4 - 5 - 6 - 7 - 8 - 9 -
      #
      #
      #   example_arr = [
      #                  ["1", "2", "3"], #=> coordinates [[0,2], [1,2], [2,2]]
      #                  ["A", "B", "C"], #=> coordinates [[0,1], [1,1], [2,1]]
      #                  ["X", "Y", "Z"]  #=> coordinates [[0,0], [1,0], [2,0]]
      #                 ]
      #
      #   load_game(example_arr)
      #           #=>     -------------
      #                 0 | 1 | 2 | 3 |
      #                   -------------
      #                 1 | A | B | C |
      #                   -------------
      #                 2 | X | Y | Z |
      #                   -------------
      #                   - 0 - 1 - 2 -
      #           #=> @height and @width will both now equal 3
      #
      #
      def load_game(saved_game)
        @board = []
        saved_game.reverse!
        @height = saved_game.length
        @width = saved_game[0].length
        saved_game.transpose.each_with_index do |row, x|
          row.each.each_with_index  do |cell, y|
            @board << Cell.new(coord: Coordinate.new(x,y), value: cell)
          end
        end
      end

      # Internal: Set up a brand new blank board
      def new_board
        @board = []
        width.times do |x|
          height.times do |y|
            @board << Cell.new(coord: Coordinate.new(x,y), value: cells)
          end
        end
      end

      # Internal: use the Coordinate::neighbors function to collect the
      #           neighbors of a given Coordinate on the existing gameboard
      # 
      # point - instance of Coordinate class at a specific x,y point
      def valid_neighbors(coord)
        coord.neighbors.collect { |point| find_cell(point) }.compact
      end
  end
end
