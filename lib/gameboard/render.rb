module Gameboard

  # to use the built in render class, pass Board#horizontal
  # to Render::board
  #
  # All methods on Gameboard::Render are class methods
  #
  class Render

    # ClassMethod: calls render methods in order of needed
    #              execution.
    #
    # gameboard - A 2D array built by Board.to_val(:horizontal)
    #
    # Example
    #
    #    Render::board(Board.new(height:3, width: 3).to_val(:horizontal))
    #
    def self.board(gameboard)
      system("tput setab 0;") unless Gem.win_platform?
      width = gameboard[0].length
      spacing
      gameboard.reverse.each_with_index do |row, i|
        row_separator(width)
        format_cells(row, i)
      end
      row_separator(width)
      column_numbers(width)
      spacing
      system("tput sgr0;") unless Gem.win_platform?
    end

    # ClassMethod: Clears the terminal for clean output
    #
    #
    # Example
    #
    #    Render::clear
    #
    def self.clear
      system("cls") || system("tput reset") || system("clear") || puts("\e[H\e[2J")
    end

    # ClassMethod: Prints a number for every column
    #
    #
    # Example
    #
    #    Render::column_numbers(8)
    #       #=> - 0 - 1 - 2 - 3 - 4 - 5 - 6 - 7 -
    #
    def self.column_numbers(columns)
      print "   "
      columns.times { |cell| print "- #{cell} " }
      puts "-"
    end

    # ClassMethod: Prints a row of cells to the screen
    #
    # row - An single dimension array of values.
    # i   - An integer for row numbers
    #
    # Example
    #
    #    Render::format_cells(["O","X", "Y"], 7)
    #        #=>  7 | O | X | Y |
    #
    def self.format_cells(row, i)
      print "#{(i < 10 ? ' ' : '')}#{i} "
      row.each_with_index do |cell,i|
        color = (i % 2) == 0 ? 6 : 3
        print "|"
        print(" #{(cell || " ")} ", color: color)
      end
      puts "|"
    end

    # ClassMethod: Prints a line of hypens to separate rows.
    #
    # columns - The number of columns in the grid.
    #
    # Example
    #
    #    Render::row_separator(7)
    #        #=>   -----------------------------
    #
    def self.row_separator(columns)
      print "   "
      columns.times { |cell| print "----" }
      puts "-"
    end

    # ClassMethod: Add consistant spacing to output.
    #
    # Example
    #    p "Word"
    #    Render::spacing
    #    p "Word 2"
    #        #=> "Word"
    #
    #            "Word 2"
    #
    def self.spacing
      puts "\n\n"
    end

    # ClassMethod: Extends the print method to allow colored
    #              output through tput.
    #
    # message - The message to be printed.
    # color   - An integer between one and seven. Numbers corolate
    #           with tput color codes
    #
    def self.print(message, color: 7)
      system("tput setaf #{color};") unless Gem.win_platform?
      super(message)
      system("tput setf 7;") unless Gem.win_platform?
    end

  end
end
