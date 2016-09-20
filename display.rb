
class Display

  def initialize(board)
    @cursor = Cursor.new([0,0], board)
    @board = board
  end

  def render
    puts "  #{(0...@board.rows.length).to_a.join(" ").colorize(:white)}"
    @board.rows.each_with_index do |row, row_num|
      row_str = row.map.with_index do |el, col_num|
        render_square(row_num, col_num, el)
      end
      row_str = row_str.join(" ")
      puts "#{row_num.to_s.colorize(:white)} #{row_str}"
    end
    nil
  end

  def render_square(row, col, el)
    string = el.to_s
    if [row, col] == @cursor.cursor_pos
      string.colorize(:red)
    else
      string.colorize(:green)
    end
  end

  def get_cursor_pos(name, &prc)
    input = nil
    until input
      system('clear')
      puts "#{name}, it is your turn! Time to move a piece."
      render
      prc.call
      input = @cursor.get_input
    end
    input
  end

end
