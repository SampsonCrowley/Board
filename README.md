# Gameboard::Board!

**CHALLENGE: WRITE A BOARD GEM!**

## Contribution Standards

- Tests on Pull Requests
- [Beautiful Code!](https://github.com/styleguide/ruby)

## Requirements

- A `Gameboard::Board` class.

- Instantiate it with:
  - Height
  - Width
  - Default Value for the cells, otherwise they are empty.

- The board is full of `Gameboard::Cell`s which have the following properties:
  - Coordinates -- Make make this is its own `Gameboard::Coordinates` class with an X and Y value
  - Value
    - This would be the checker in checkers, piece in chess, mine in minesweeper...

- Includes the Enumerable module.

- Methods, for modifying Board data:
  - Gameboard::Board.randomize(value)
  - Gameboard::Board.set_cell([x,y], value)

- Methods for returning different arrangements of cells of the on the board:
  - Gameboard::Board.horizontal
  - Gameboard::Board.vertical
  - Gameboard::Board.diagonal

- Methods for returning cells:
  - Gameboard::Board.find_cell([x,y])
  - Gameboard::Board.delta([x,y],[slope])
  - Gameboard::Board.neighbors([x,y])


