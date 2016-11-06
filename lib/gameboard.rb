require "gameboard/version"
require "gameboard/render"
require "gameboard/board"


module Gameboard
  # Public: a purely coordinate based gameboard
  # run the preview executable to preview the Render class
  #
  # Class List:
  #
  # Board
  # Cell
  # Coordinate
  # Render
  #
  # Examples
  #
  #   include Gameboard
  #   board = Board.new(width:10, height: 8, cells: "O")
  #   Render.board(board.horizontal)
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
  # Render.board assumes that data is being passed row by row
end
