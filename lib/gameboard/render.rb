module Gameboard

  # to use the built in render class, pass Board.horizontal to Render.board

  class Render
    def self.board(board)
    width = board[0].length
    clear
    spacing
    board.reverse.each_with_index do |row, i|
      row_separator(width)
      format_cells(row, i)
    end
    row_separator(width)
    column_numbers(width)
    spacing
  end

  def self.clear
    system("cls") || system("tput reset") || system("clear") || puts("\e[H\e[2J")
  end

  def self.column_numbers(columns)
    print "   "
    columns.times { |cell| print "- #{cell} " }
    puts "-"
  end

  def self.format_cells(row, i)
    print "#{(i < 10 ? ' ' : '')}#{i} "
    row.each do |cell|
      print "| #{(cell || " ")} "
    end
    puts "|"
  end

  def self.row_separator(columns)
    print "   "
    columns.times { |cell| print "----" }
    puts "-"
  end

  def self.spacing
    puts "\n\n"
  end

  def self.winner(player)
    puts "########GAMER OVER########\n\n"
    puts "#{player} wins!\n\n"
  end
  end
end
