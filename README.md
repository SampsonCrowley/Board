# Bored::Board!

**CHALLENGE: WRITE A BOARD GEM!**

## Contribution Standards

- Tests on Pull Requests
- [Beautiful Code!](https://github.com/styleguide/ruby)

## Requirements

- A `Bored::Board` class.

- Instantiate it with:
  - Height
  - Width
  - Default Value for the cells, otherwise they are empty.
  
- The board is full of `Bored::Cell`s which have the following properties:
  - Coordinates -- Make make this is its own `Bored::Coordinates` class with an X and Y value
  - Value
    - This would be the checker in checkers, piece in chess, mine in minesweeper...
    
- Include the Enumerable module.

- Methods for returning different arrangements of cells of the on the board:
  - Horizontals
  - Verticals
  - Diagonals
  
- Methods for returning cells:
  - Return the neighbors of a given coordinate.
  - Maybe: Return a cell given coordinates and a delta. [0,2] and [1,1] should return the cell at[1,3]
 
 - Whatever fun methods you can think of...
