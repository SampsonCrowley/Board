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
    # height      - The number of horizontal rows on the gameboard. Not
    #               passing a height will raise an ArgumentError unless a
    #               preset board is passed.
    # width       - The number of columns on the gameboard. Not passing a
    #               width will raise an ArgumentError unless a preset board
    #               is passed.
    # cell_value  - An optional value, preferably a String in most cases,
    #               that changes the default cell value.
    # preset -      An optional 2D Array to load a preset gameboard. Saved
    #               games should be created in rows from the top down.
    #
    # Examples
    #
    #   board = Board.new(cell_value: "O", width: 10, height: 8)
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
    def initialize(height: nil, width: nil, cell_value: nil, preset: false)
      raise ArgumentError unless ((height.is_a?(Integer) && width.is_a?(Integer)) || !!preset)
      @height = height
      @width = width
      @nailed = false
      @default_cell = cell_value
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

    # Public: An enumerator that yields each cell's value.
    # Example
    #
    #   board.each_value { |cell| p cell }
    #     #=> "O"
    #     #=> "X"
    #     #=> "X"...
    #
    def each_value(&block)
      return enum_for(__method__) if block.nil?
      each{|cell| yield(cell.val)}
    end

    # Public: An enumerator that yields each cell's coordinates.
    # Example
    #
    #   board.each { |cell| p cell }
    #     #=> Coordinate (.position == [0, 0])
    #     #=> Coordinate (.position == [1, 0])
    #     #=> Coordinate (.position == [2, 0])
    #     #=> Coordinate (.position == [0, 1])
    #     #=> Coordinate (.position == [1, 1])...
    #
    def each_coordinate(&block)
      return enum_for(__method__) if block.nil?
      each { |cell| yield(cell.coord) }
    end

    # Public: Return the value of the next available point given a coordinate
    #         and a slope.
    #
    # point  - The starting point. [x, y] coordinate
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
    def delta(point, slope)
      base = find_cell(point)
      find_cell(base.coord.send(:delta, slope))
    end

    # Public: Return an Array of Gameboard::Cell for every diagonal on the gameboard. It does not
    #         require a square board to function. Run #to_val(:diagonal) if you only need the
    #         values at each index
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
    #     #=> Note: Values above are for demonstration. Each value will actually be a
    #               Gameboard::Cell with methods #coord and #val
    #
    #
    def diagonal
      diagonals = []

      height.times do |i|
        diagonals << get_diagonal([0, i])
        diagonals << get_diagonal([0, height - 1 - i], -1)
      end
      (1...width).each do |i|
        diagonals << get_diagonal([i, 0])
        diagonals << get_diagonal([i, height - 1], -1)
      end
      diagonals
    end

    def empty?
      board.all? { |cell| cell.val == default_cell  }
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

    # Public: Resets the board unless nailed down. All pieces will be set
    #         to the default value.
    #
    def flip
      raise "The Board is Nailed to the Table" unless !nailed_down?
      board.each {|cell| cell.val = default_cell}
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
    #   Board.new(height: 3, width: 3, default: "Y")
    #
    #   full?
    #     #=> false (because our default piece is now "Y")
    #
    def full?
      board.none? { |cell| cell.val == default_cell  }
    end

    # Public: Return every row on the gameboard. Run #to_val(:horizontal) if you only need the
    #         values at each index
    #
    #
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
    #     #=> Note: Values above are for demonstration. Each value will actually be a
    #               Gameboard::Cell with methods #coord and #val
    #
    def horizontal
      rows = []
      height.times do |y|
        rows << board.select { |cell| cell.coord.y == y }
      end
      rows
    end

    # Public: Nail the board down so it can't be flipped.
    def nail_down
      @nailed = true
    end

    # Public: Return whether the board is nailed down.
    def nailed_down?
      !!nailed
    end

    # Public: Return an array of Gameboard::Cell for valid neighbors of a given coordinate.
    #
    # coord  - an [x, y] coordinate
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
    #   neighbors(Coordinate.new(0,0))
    #           #=> [1, 2, 3, "A", "C", "X", "A", 1]
    #
    def neighbors(coord)
      find_cell(coord).coord.neighbors.map { |point| find_cell(point) }.compact
    end

    # Public: Set random cells to a given value.
    #
    # piece - A value to set to cells
    #
    def randomize(piece)
      rand(1...board.length).times do
        board[rand(board.length)].val = piece
      end
    end
    # Public: Set a cell's value at a given coordinate. Returns false if no cell found
    #
    # coord - A coordinate pair in the form X, Y
    #
    def set_cell(coord, value)
      cell = find_cell(coord)
      return false unless cell
      cell.val = value if cell
    end

    # Public: Return every column on the gameboard. Run #to_val(:vertical) if you only need the
    #         values at each index
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
    #     #=> Note: Values above are for demonstration. Each value will actually be a
    #               Gameboard::Cell with methods #coord and #val
    #
    def vertical
      columns = []
      width.times do |x|
        columns << board.select { |cell| cell.coord.x == x }
      end
      columns
    end

    # Public: Helper method to return values instead of Cells for a given method.
    #
    # method_sym - A symbol of the method you want to run.
    # args       - optional, pass an argument to the method you are calling
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
    #   to_val(:vertical)
    #     #=> [
    #          ["X", "A", 1],
    #          ["Y", "B", 2],
    #          ["Z", "C", 3]
    #         ]
    def to_val(method_sym, args = (no_args = true; nil))
      (no_args ? public_send(method_sym) : public_send(method_sym,args)).map do |item|
        item.is_a?(Array) ? item.collect { |cell| cell.val } : item.val
      end
    end
    
    private
      # Internal: Returns the gameboard array.
      attr_reader :board
      # Internal: Returns the default gameboard cell value
      attr_reader :default_cell
      # Internal: Stores whether the board is nailed down
      attr_reader :nailed

      # Internal: return a diagonal array given a starting point and a
      #           slope.
      def get_diagonal(start, slope = 1)
        diagonal = (0...height).map do |i|
          delta(start, [i, i * slope])
        end
        diagonal.compact
      end

      # Internal: Set the current gameboard.
      #
      # saved_game - An 2D Array. Saved games should be created in rows from
      #              the top down.
      #
      #
      # Examples
      #
      #   board = Board.new(default_cell: "O", width: 10, height: 8)
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
            @board << Cell.new(coord: Coordinate.new(x,y), val: cell)
          end
        end
      end

      # Internal: Set up a brand new blank board
      def new_board
        @board = []
        width.times do |x|
          height.times do |y|
            @board << Cell.new(coord: Coordinate.new(x,y), val: default_cell)
          end
        end
      end
  end
end
